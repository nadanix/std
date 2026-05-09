# AGENTS.md (QuoIntelligence/std)

This repository is the "std" Nix Flakes framework. It is organized as Cells
(`src/<cell>/`) and Cell Blocks (Nix files inside a cell).
This file is for agentic coding agents working in this checkout.

## Repo Rules (Read First)

- Enter the dev environment before running serious commands: `direnv allow`
  (fallback: `nix develop -c "$SHELL"`).
- Formatting is enforced: run `treefmt` (Alejandra for Nix). Do not use `nixfmt`.
- Keep PRs small; avoid treewide formatting churn unless explicitly requested.
- Hooks: Lefthook `pre-commit` runs `treefmt --fail-on-change`; `commit-msg` runs
  Conform (conventional commits + SPDX headers).
- Copilot rules: `.github/copilot-instructions.md` (authoritative).
- Cursor rules: none (`.cursor/rules/` and `.cursorrules` are absent).

## Agent-Facing Repo Knowledge

Treat `AGENTS.md` as a map, not a handbook. For repo-local architecture and
agent harness guidance, read:

1. `docs/00-map.md`
2. `docs/architecture/00-map.md`
3. `docs/agent/validation-harness.md`

## Vendored Design Context

For reusable architecture/domain-modeling guidance, read:

1. `docs/vendor/design-context/README.md`
2. `docs/vendor/design-context/context/00-map.md`
3. `docs/vendor/design-context/context/manifests/project-manifest.yaml`

Load only the smallest relevant leaf docs for the task. Do not recursively
follow every related link or manifest `next_reads` entry. Project-specific docs
under `docs/` override generic vendored guidance when they conflict. Do not edit
`docs/vendor/design-context/` unless explicitly asked to update the vendored
pack.

## Layout (What Lives Where)

- `flake.nix`: top-level flake (bootstraps fwlib, then dogfoods).
- `dogfood.nix`: how std uses std (devshells, configs, checks, templates).
- `src/std/`: framework core (`fwlib/`, `fwlib/blockTypes/`, `templates/`).
- `src/lib/`: helper libs (`dev`, `ops`) and repo cfg helpers.
- `src/data/`: reusable config data (`treefmt`, `mdbook`, `lefthook`, etc).
- `src/local/`: this repo's devshell + nixago pebbles.
- `src/tests/`: snapshot suite wiring (Namaka).
- `tests/`: snapshot sources; `tests/_snapshots/` is the golden output.

## Commands (Copy/Paste)

```bash
# Enter / reload env
direnv allow
direnv reload
nix develop -c "$SHELL"

# Build
nix build
SYSTEM="$(nix eval --raw --expr builtins.currentSystem)"
nix build .#packages.${SYSTEM}.std

# Docs (in devshell)
mdbook build
mdbook serve

# Format / lint (required pre-commit)
treefmt
treefmt $(git diff --name-only --cached)
reuse lint

# Tests (closest to CI)
nix flake check

# Snapshot tests (Namaka)
namaka check
namaka review
namaka clean

# Same via std CLI/TUI
std //tests/checks/snapshots:check
std //tests/checks/snapshots:review
std //tests/checks/snapshots:clean
```

Notes:

- Some `nix` commands (notably `nix flake metadata`) may rewrite lock files.
  For read-only inspection use `--no-write-lock-file`.

## Running a Single Snapshot Test (Current Limitation)

- Snapshot checks are evaluation-time and currently load all of `tests/` in one go.
- Usual workflow: run `namaka check`, then focus on the failing snapshot(s) in
  `namaka review`.

If you truly need isolation, temporarily filter the loader in `src/tests/checks.nix`
using Haumea's `transformer` and revert before committing:

```nix
# Example: run only bt-blocktypes (top-level cursor == [])
check = namaka.lib.load {
  src = self + /tests;
  inputs = inputs' // { inputs = inputs'; };
  transformer = [
    (cursor: attrs: if cursor == [] then { bt-blocktypes = attrs.bt-blocktypes; } else attrs)
  ];
};
```

## Updating Flake Inputs / Locks

- After editing any `flake.nix`, run `nix flake update` in that flake directory.
- This repo has subflakes; update them explicitly when touched:

```bash
nix flake update
nix flake update --flake ./src/data
nix flake update --flake ./src/local
nix flake update --flake ./src/tests
```

- Subflakes track in-repo std via a store-path lock; update those pins with:

```bash
./.github/workflows/update-subflake.sh
```

## Code Style Guidelines

### Nix (Most Of The Repo)

- Formatting: let `treefmt`/Alejandra do it; do not hand-format.
- Imports/args: cell blocks are typically `{ inputs, cell, ... }:`; avoid
  `<nixpkgs>` and ad-hoc `import <...>`.
- Common idioms:
  - `l = inputs.nixpkgs.lib // builtins;`
  - `inherit (inputs) nixpkgs;`
  - `pkgs = inputs.nixpkgs.${currentSystem};` (in actions)
- Naming:
  - Cells: directories under `src/` (lowercase).
  - Cell blocks: usually plural (`shells`, `configs`, `checks`).
  - Targets: short, stable (`default`, `snapshots`, ...).
- Types/options (framework code): prefer `lib.types` / `mkOption` and yants-style
  checks where the surrounding code already does.
- Error handling: prefer `lib.assertMsg` / `abort` with actionable text; include
  "what failed" and "how to fix".

### Framework Internals

- Block types live in `src/std/fwlib/blockTypes/`; follow the existing pattern:
  `{ root, super }: name: { type = "..."; actions = { ... }: [ (mkCommand ...) ... ]; }`.
- Declare runtime deps for action scripts via the deps list (do not assume global tools).
- Actions assume PRJ-spec env (`PRJ_ROOT`, `PRJ_DATA_HOME`, `PRJ_CACHE_HOME`).

### Shell

- `mkCommand` scripts run with `errexit`, `nounset`, `pipefail` and are shellchecked.
- Quote variables; propagate non-zero exit codes; keep scripts small and explicit.

### Snapshots

- `tests/_snapshots/*` is exact. Update via `namaka review`, not by hand.

## Git / Commits

- Conventional commits are enforced by Conform (types/scopes in
  `src/data/configs/conform.nix`).
- Subject line max length: 89 chars.
- SPDX headers are required where applicable.
