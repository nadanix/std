# Devshells

- The `default` devshell implements the development environment for the `std` TUI/CLI.
- Furthermore, it implements a `pre-commit` hook to keep the source code formatted.
- It makes use of `std.lib.mkShell` which is a convenience proxy for `numtide/devshell`.

## Updating nixpkgs

Treat the root `flake.lock` as the canonical nixpkgs pin:

```sh
nix flake update nixpkgs
./.github/workflows/update-subflake.sh
```

The synchronization script aligns `src/local/flake.lock`, `src/tests/flake.lock`
and `src/data/flake.lock` with the root revision without updating their other
inputs or staging files. Run it after any root nixpkgs update; the dogfood
snapshot tests check that all four locks contain one identical nixpkgs pin.
