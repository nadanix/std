# Devshells

- The `default` devshell implements the development environment for the `std` TUI/CLI.
- Furthermore, it implements a `pre-commit` hook to keep the source code formatted.
- It makes use of `std.lib.mkShell` which is a convenience proxy for `numtide/devshell`.

## Dependency policy

All eight repository `flake.nix` files (including templates and tutorials) use
floating inputs or `follows`. Revisions belong in `flake.lock`, not in input URLs.
There are currently **no version-pin exceptions**. The root flake's Nix 2.13
assertion is a minimum runtime requirement, not a dependency pin.

The private flakes declare transitive inputs explicitly and connect them with
`follows`: Nixago's `flake-utils`/`systems`, Arion's `haskell-flake`/`flake-parts`,
Terranix's `import-tree`/`systems`/`flake-parts`, and MicroVM's `spectrum`. This
avoids retaining stale upstream lock entries during a full update, including
Arion's upstream `haskell-flake/1.0.0` tag. New helper inputs remain private;
`flake-parts` retains its existing cell-facing export. The dogfood tests check
both floating declarations/lock origins and private-input isolation.

## Updating all dependencies

From the repository root:

```sh
nix flake update --refresh
for cell in local tests data; do
  nix flake update --refresh --flake "./src/$cell"
done
./.github/workflows/update-subflake.sh
nix flake check
```

Updating the root alone does not update the three independent private locks.
The final synchronization keeps a single canonical nixpkgs revision even if its
upstream branch advances during the updates. Templates and tutorials do not
have committed lock files; do not generate locks for them here.

For a freshness audit, compare every locked source revision (including
transitive inputs) with its repository's default-branch `HEAD`, for example with
`git ls-remote <repository-url> HEAD`. An old commit date can still be the latest
commit of an inactive repository. Do not treat a successful update that reports
a cached fallback after a network/API error as proof of freshness.

The input-source snapshot records store paths, so dependency updates can require
reviewing and accepting its new paths with Namaka before `nix flake check` passes.

## Updating only nixpkgs

Treat the root `flake.lock` as the canonical nixpkgs pin:

```sh
nix flake update nixpkgs
./.github/workflows/update-subflake.sh
```

The synchronization script aligns `src/local/flake.lock`, `src/tests/flake.lock`
and `src/data/flake.lock` with the root revision without updating their other
inputs or staging files. Run it after any root nixpkgs update; the dogfood
snapshot tests check that all four locks contain one identical nixpkgs pin.
