#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 The Standard Authors
# SPDX-License-Identifier: Unlicense

set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

failures=0

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  failures=$((failures + 1))
}

require_file() {
  local path=$1
  if [[ ! -e $path ]]; then
    fail "missing required file: $path"
  fi
}

require_grep() {
  local pattern=$1
  local path=$2
  local message=$3
  if ! grep -Eq "$pattern" "$path"; then
    fail "$message"
  fi
}

required_docs=(
  AGENTS.md
  docs/00-map.md
  docs/architecture/00-map.md
  docs/architecture/std-domain-model.md
  docs/architecture/bounded-contexts.md
  docs/architecture/dependency-contracts.md
  docs/architecture/workflows.md
  docs/architecture/action-runtime.md
  docs/architecture/block-type-catalog.md
  docs/architecture/invariants.md
  docs/architecture/quality-score.md
  docs/agent/00-map.md
  docs/agent/validation-harness.md
  docs/agent/doc-gardening.md
  docs/agent/review-and-merge-philosophy.md
  docs/manifests/architecture-manifest.yaml
  docs/manifests/dependency-contracts-manifest.yaml
  docs/generated/block-types.md
  docs/generated/std-registry.md
)

for path in "${required_docs[@]}"; do
  require_file "$path"
done

agents_lines=$(wc -l <AGENTS.md | tr -d ' ')
if ((agents_lines > 220)); then
  fail "AGENTS.md has $agents_lines lines; keep it map-sized (<= 220)"
fi

require_grep 'docs/00-map\.md' AGENTS.md "AGENTS.md should point agents to docs/00-map.md"
require_grep 'docs/vendor/design-context/README\.md' AGENTS.md "AGENTS.md should point to vendored design-context"

while IFS= read -r manifest_path; do
  [[ -z $manifest_path ]] && continue
  require_file "$manifest_path"
done < <(
  grep -hE '^[[:space:]]*(- )?(path|map): ' docs/manifests/*.yaml |
    sed -E 's/.*(path|map):[[:space:]]*//; s/[[:space:]]*$//'
)

for source in src/std/fwlib/blockTypes/*.nix; do
  file=$(basename "$source")
  [[ $file == _* ]] && continue
  require_grep "\`$file\`" docs/architecture/block-type-catalog.md \
    "Block Type $file is missing from docs/architecture/block-type-catalog.md"
  require_grep "\`$source\`" docs/generated/block-types.md \
    "Block Type $source is missing from docs/generated/block-types.md"
done

root_inputs=()
if command -v nix >/dev/null 2>&1; then
  if input_list=$(nix eval --raw --impure --expr 'builtins.concatStringsSep "\n" (builtins.attrNames (import ./flake.nix).inputs)'); then
    while IFS= read -r input; do
      [[ -z $input ]] && continue
      root_inputs+=("$input")
    done <<<"$input_list"
  else
    fail "could not evaluate root flake inputs with nix"
  fi
else
  fail "nix is required to validate root dependency contracts"
fi

for input in "${root_inputs[@]}"; do
  require_grep "\`$input\`" docs/architecture/dependency-contracts.md \
    "root input $input is missing from docs/architecture/dependency-contracts.md"
  require_grep "input: $input" docs/manifests/dependency-contracts-manifest.yaml \
    "root input $input is missing from docs/manifests/dependency-contracts-manifest.yaml"
done

if ((failures > 0)); then
  printf '\nagent knowledge checks failed: %d issue(s)\n' "$failures" >&2
  exit 1
fi

printf 'agent knowledge checks passed\n'
