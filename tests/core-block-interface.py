# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense
"""Exercise the real core importer, including its ordinary (non-trace) errors."""

import argparse
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

parser = argparse.ArgumentParser()
for option in ("driver", "core", "nixlib", "yants", "nosys"):
    parser.add_argument(f"--{option}", required=True)
args, unittest_args = parser.parse_known_args()


class BlockInterfaceTests(unittest.TestCase):
    function = """{ inputs, cell }: let
      answer = inputs.value;
    in { inherit answer; localValue = cell.sibling.value; }
    """

    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.cells = Path(self.temp.name) / "cells"
        self.cell = self.cells / "demo"
        self.cell.mkdir(parents=True)
        (self.cell / "sibling.nix").write_text(
            "{ inputs, cell }: { value = 7; }\n"
        )

    def evaluate(self, source, directory=False):
        relative = "block/default.nix" if directory else "block.nix"
        path = self.cell / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(source)
        command = [
            "nix-instantiate", "--eval", "--strict", "--json",
            "--store", "dummy://", "--extra-experimental-features", "nix-command flakes",
            "--option", "builders", "",
            "--option", "accept-flake-config", "false",
        ]
        for key, value in {
            "corePath": args.core,
            "nixlibPath": args.nixlib,
            "yantsPath": args.yants,
            "nosysPath": args.nosys,
            "cellsFrom": str(self.cells),
        }.items():
            command.extend(["--argstr", key, value])
        command.append(args.driver)
        return subprocess.run(
            command, text=True, capture_output=True, timeout=30
        )

    def assert_migration_error(self, source, directory=False):
        result = self.evaluate(source, directory)
        self.assertNotEqual(result.returncode, 0, result.stdout)
        relative = "block/default.nix" if directory else "block.nix"
        self.assertIn(f"cells/demo/{relative}", result.stderr)
        self.assertIn("Cell Blocks must be functions", result.stderr)
        self.assertIn("Attribute-set Cell Blocks are no longer supported", result.stderr)
        self.assertIn("{ inputs, cell }:", result.stderr)
        self.assertIn("before the entire expression", result.stderr)
        return result

    def test_functions_receive_inputs_and_sibling_cell(self):
        for directory in (False, True):
            with self.subTest(directory=directory):
                # Separate instances prevent the file-precedence rule hiding a directory.
                (self.cell / "block.nix").unlink(missing_ok=True)
                result = self.evaluate(self.function, directory)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(json.loads(result.stdout), {"answer": 42, "localValue": 7})

    def test_file_still_takes_precedence_over_directory(self):
        directory = self.cell / "block"
        directory.mkdir()
        (directory / "default.nix").write_text('throw "Directory must not be loaded"')
        result = self.evaluate(self.function)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(json.loads(result.stdout)["answer"], 42)

    def test_attrsets_rejected_in_both_locations_without_forcing_targets(self):
        for directory in (False, True):
            with self.subTest(directory=directory):
                (self.cell / "block.nix").unlink(missing_ok=True)
                result = self.assert_migration_error(
                    '{ answer = throw "Target must not be evaluated"; }', directory
                )
                self.assertNotIn("Target must not be evaluated", result.stderr)

    def test_implicit_inputs_and_cell_have_migration_context(self):
        sources = [
            "{ answer = inputs.value; }",
            "{ answer = cell.sibling.value; }",
            "let inherit (inputs) value; in { answer = value; }",
        ]
        for directory in (False, True):
            for source in sources:
                with self.subTest(directory=directory, source=source):
                    (self.cell / "block.nix").unlink(missing_ok=True)
                    self.assert_migration_error(source, directory)

    def test_callable_attrsets_are_not_functions(self):
        self.assert_migration_error(
            "{ __functor = self: { inputs, cell }: { answer = inputs.value; }; }"
        )

    def test_no_ambient_scope_outside_function_parameters(self):
        self.assert_migration_error(
            "let value = inputs.value; in { inputs, cell }: { answer = value; }"
        )

    def test_signature_validation_is_preserved(self):
        for source in [
            "{ inputs }: { answer = inputs.value; }",
            "{ inputs ? {}, cell }: { answer = inputs.value; }",
            "args: { answer = args.inputs.value; }",
        ]:
            with self.subTest(source=source):
                self.assert_migration_error(source)

    def test_other_nonfunctions_are_rejected(self):
        for source in ("null", "42", '"not a Block"', "[]"):
            with self.subTest(source=source):
                self.assert_migration_error(source)

    def test_function_must_still_return_a_target_set(self):
        result = self.evaluate('{ inputs, cell }: "not a Target set"')
        self.assertNotEqual(result.returncode, 0, result.stdout)
        self.assertIn("cells/demo/block.nix", result.stderr)
        self.assertIn("attrs<any>", result.stderr)


if __name__ == "__main__":
    unittest.main(argv=[__file__, *unittest_args])
