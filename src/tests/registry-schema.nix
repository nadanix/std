# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense
{
  runCommand,
  python3,
}:
runCommand "std-registry-schema-tests" {
  nativeBuildInputs = [(python3.withPackages (p: [p.jsonschema]))];
} ''
  python3 ${../../tests/registry-schema.py} ${../std/core/registry.schema.json}
  touch "$out"
''
