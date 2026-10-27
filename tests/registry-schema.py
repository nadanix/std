# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense

"""Data-only CI metadata contract tests; see src/tests/registry-schema.nix."""

import json
from pathlib import Path
import sys
import unittest

from jsonschema import Draft202012Validator


class RegistrySchemaTests(unittest.TestCase):
    schema_path = Path(__file__).resolve().parents[1] / "src/std/core/registry.schema.json"

    @classmethod
    def setUpClass(cls):
        schema = json.loads(cls.schema_path.read_text())
        Draft202012Validator.check_schema(schema)
        cls.validator = Draft202012Validator(schema)

    def registry(self, **fields):
        # Representative data, not evaluated Actions or real store paths.
        candidate = {
            "cell": "example",
            "block": "images",
            "blockType": "containers",
            "name": "image",
            "action": "publish",
            "actionDrv": "/nix/store/example-publish.drv",
            "targetDrv": None,
            "proviso": None,
            **fields,
        }
        return {
            "__schema": "v0",
            "cellsFrom": "cells",
            "init": {},
            "actions": {},
            "ci": {"x86_64-linux": [candidate]},
        }

    def test_object_metadata(self):
        for meta in [
            # Shape emitted by src/std/fwlib/blockTypes/containers.nix.
            {"image": "example.invalid/image:tag"},
            {},
            # No global image requirement or closed set of metadata keys.
            {"custom": {"enabled": True, "values": [1, "two", None]}},
        ]:
            with self.subTest(meta=meta):
                self.validator.validate(self.registry(meta=meta))

    def test_null_metadata(self):
        self.validator.validate(self.registry(action="build", meta=None))

    def test_metadata_is_optional(self):
        self.validator.validate(self.registry(action="build"))

    def test_non_object_metadata_is_rejected(self):
        for meta in [
            "example.invalid/image:tag",
            '{"image":"example.invalid/image:tag"}',
            "",
            [],
            [{"image": "example.invalid/image:tag"}],
            True,
            False,
            1,
            1.5,
        ]:
            with self.subTest(meta=meta):
                errors = list(self.validator.iter_errors(self.registry(meta=meta)))
                self.assertEqual(len(errors), 1, errors)
                self.assertEqual(list(errors[0].absolute_path), ["ci", "x86_64-linux", 0, "meta"])
                self.assertEqual(errors[0].validator, "type")

    def test_required_candidate_fields_remain_required(self):
        registry = self.registry(meta={})
        del registry["ci"]["x86_64-linux"][0]["actionDrv"]
        errors = list(self.validator.iter_errors(registry))
        self.assertEqual(len(errors), 1, errors)
        self.assertEqual(list(errors[0].absolute_path), ["ci", "x86_64-linux", 0])
        self.assertEqual(errors[0].validator, "required")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        RegistrySchemaTests.schema_path = Path(sys.argv.pop(1))
    unittest.main(verbosity=2)
