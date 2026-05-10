# Plan: absorb Paisano into std

## Goal

Make `std` own the Paisano pieces it depends on today:

- the core importer/registry functions (`grow`, `growOn`, `pick`, `harvest`, `winnow`);
- the Go CLI/TUI source currently consumed from `paisano-tui`;
- the Rust mdBook preprocessor currently consumed from `mdbook-paisano-preprocessor`.

The end state removes those remote inputs from the root and subflake locks while
preserving the public `std` API and the `#__std` registry contract.

## Scope

In scope:

- vendor/absorb runtime source needed by `std`;
- keep public names stable first (`std`, `#__std`, `paisano-preprocessor`);
- update dependency contracts and generated snapshots after each source move;
- keep validation green after each phase.

Out of scope for the first pass:

- redesigning the registry schema;
- renaming the mdBook preprocessor in user-facing `book.toml`;
- rewriting the Go TUI internals beyond source relocation;
- removing every remaining Divnix dependency in one step.

## Current state

- `paisano/core` has been copied into `src/std/_sources/paisano-core` and is
  imported through `src/std/fwlib/paisano.nix`.
- `paisano-tui` has been copied into `src/std/_sources/paisano-tui`; the `std`
  package builds from this local source.
- `mdbook-paisano-preprocessor` has been copied into
  `src/std/_sources/mdbook-paisano-preprocessor`; the mdBook config builds it
  locally with `nixpkgs.rustPlatform.buildRustPackage`.
- The root and subflake locks no longer need `paisano`, `paisano-tui`, or the
  data-subflake `mdbook-paisano-preprocessor` input. `call-flake` and `nosys`
  remain as temporary direct helpers for the absorbed core.

## Steps

### Phase 1: absorb Paisano core

- [x] Copy the core importer/soil/type sources into `src/std/_sources/paisano-core`.
- [x] Add a thin `src/std/fwlib/paisano.nix` adapter that imports those local
      sources.
- [x] Change `src/std/fwlib/grow.nix`, `src/std/fwlib/growOn.nix`, `flake.nix`, and
      `dogfood.nix` to use the local adapter instead of `inputs.paisano`.
- [x] Replace the root `paisano` input with direct temporary inputs for any still
      external implementation helpers (`call-flake`, `nosys`) if needed.
- [x] Update locks, dependency docs, and snapshots.

### Phase 2: absorb Paisano TUI

- [x] Copy the Go source from `paisano-tui` into `src/std/_sources/paisano-tui`.
- [x] Point `src/std/cli.nix` at the local source path.
- [x] Keep ldflags and the binary rename behavior stable.
- [x] Remove the `paisano-tui` root input and refresh locks.

### Phase 3: absorb mdBook Paisano preprocessor

- [x] Copy the Rust source into `src/std/_sources/mdbook-paisano-preprocessor`.
- [x] Build it locally from `src/data/configs/mdbook.nix`.
- [x] Keep `[preprocessor.paisano-preprocessor]` stable initially.
- [x] Remove the `mdbook-paisano-preprocessor` input from `src/data/flake.nix` and
      refresh `src/data/flake.lock`.
- [ ] Decide separately whether to rename it to a `std`-branded preprocessor
      and whether to upgrade from mdBook 0.4 to 0.5.

### Phase 4: cleanup and ownership docs

- [x] Remove obsolete remote inputs and stale lock nodes.
- [x] Update `docs/architecture/dependency-contracts.md` and manifests from
      supplier-owned to internally-owned components.
- [ ] Update generated registry/docs snapshots if changed.
- [x] Record any remaining external helpers (`call-flake`, `nosys`, `yants`) as
      explicit internal implementation dependencies.

## Validation

Run after each phase:

```bash
nix flake check --no-write-lock-file
nix develop --no-write-lock-file -c namaka check
nix develop --no-write-lock-file -c mdbook build
nix develop --no-write-lock-file -c reuse lint
git diff --check
```

Spot checks:

```bash
nix eval --json --no-write-lock-file .#__std.init.x86_64-linux
nix run --no-write-lock-file .#std -- --help
rg "inputs\.paisano|inputs\.paisano-tui|mdbook-paisano-preprocessor\.url" flake.nix src
```

## Decision log

- Start with local source plus thin adapters to preserve API behavior and make
  diffs reviewable.
- Keep the mdBook preprocessor command/config name stable until the absorbed
  implementation is green.
- Defer removal of lower-level Divnix helpers until after the public Paisano
  inputs are gone.
