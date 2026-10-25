# Setup `.envrc`

Standard's direnv library loads a devshell through its `__std` registry and watches
Cell Blocks that can change the environment. It provides `use env` (load once)
and `use envreload` (watch and load).

## External projects

The templates contain only a small `.envrc`, not a copy of the library. It fetches
`src/std/direnv/lib.sh` from a published commit of `nadanix/std`. Both the commit
and the integrity hash are fixed, and direnv caches the verified download:

```bash
{{#include ../../src/std/templates/minimal/.envrc}}
```

The `std` flake input uses `github:nadanix/std`, without a revision in `flake.nix`.
The project's `flake.lock` records its resolved revision independently of the
shell-library pin.

The first selector chooses the devshell to enter. Additional selectors only add
file watches. Selectors use `//cell/block/target`; a whole block can be watched
with `//cell/block`. The library discovers the Cell directory (`nix`, `cells`,
etc.) from `__std.cellsFrom`; do not pass it as a separate argument.

The Rust template expects an existing Cargo project with `Cargo.toml`,
`Cargo.lock` and `src/`. Include these files in Git as well.

The registry uses the Git checkout. In a newly generated project, initialize Git
and lock the flake before allowing direnv:

```console
git init
git add .
nix flake lock
git add flake.lock
direnv allow
```

If the project already has Git and a lock file, only `direnv allow` is needed.
Changes to `.envrc` require approval again; `direnv reload` explicitly reloads the
environment without changing the library's pinned revision.

When updating the library, publish its commit first, obtain the integrity hash
with `direnv fetchurl <immutable-url>`, then update the URL and hash together.
Do not point consumers at a moving branch such as `main`.

## Working on Standard

This repository loads the same library directly from the checkout and watches it
for changes:

```bash
{{#include ../../.envrc}}
```

The explicit `cellsFrom=src` makes watches refer to working-tree files rather than
the name of a filtered source in the Nix store. Loading the default shell watches:

```console
direnv: Watching: src/local/shells.nix
direnv: Watching: src/local/configs.nix
```

The library still uses the pinned `numtide/prj-spec` bootstrap to establish the
`PRJ_*` directories. Profiles live under `PRJ_DATA_HOME`; the Rust template also
uses it for Cargo and rustup, rather than the old `PRJ_DATA_DIR` alias.
