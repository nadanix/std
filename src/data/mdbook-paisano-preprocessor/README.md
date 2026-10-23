# mdBook preprocessor

The upstream source is pinned in `src/data/flake.lock` as a **non-flake** input.
Its Nix build still depends on the 2023 Standard/Crane/Fenix stack; importing that
flake would reintroduce two old nixpkgs revisions. Instead, the data flake builds
it with `rustPlatform` from the same nixpkgs revision as the repository root.

`mdbook-0.5.patch` adapts the preprocessor to mdBook 0.5's dedicated
`mdbook-preprocessor` crate, configuration API and renderer-support protocol.
`Cargo.lock` was regenerated from the patched upstream manifest and is used for
both dependency fetching and the build. When updating the patch or upstream,
regenerate this Cargo lock from the patched source and check compatibility with
the mdBook version in the root nixpkgs lock.

Run the protocol smoke test (replace the system when appropriate):

```sh
nix build --no-link './src/data#mdbook-paisano-preprocessor.packages.x86_64-linux.default.tests.mdbook'
```

The smoke test invokes the real mdBook executable, checks HTML renderer support
and verifies that a chapter survives the preprocessor's JSON protocol. The full
integration test also exercises Nix evaluation and reference generation:

```sh
nix develop .#book -c mdbook build
```

Synchronize private nixpkgs pins after updating the root lock:

```sh
./.github/workflows/update-subflake.sh
```
