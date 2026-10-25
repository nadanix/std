# mdBook preprocessor

The data flake builds these local sources with `rustPlatform` from the same
nixpkgs revision as the repository root. It retains the
`mdbook-paisano-preprocessor.packages.<system>.default` provider, executable name
and `preprocessor.paisano-preprocessor` configuration key. There is no separate
flake in this directory.

## Provenance

Imported from [paisano-nix/mdbook-paisano-preprocessor](https://github.com/paisano-nix/mdbook-paisano-preprocessor/tree/f84fc450aaf4824b4d64d957349553c0f8acc243),
revision `f84fc450aaf4824b4d64d957349553c0f8acc243`, previously pinned in
`src/data/flake.lock`. The import includes `Cargo.toml`, `src/`, `assets/` and
`templates/`; both assets and templates are embedded during compilation.

The existing `mdbook-0.5.patch` has been applied directly to the sources. It adapts
the preprocessor to mdBook 0.5's dedicated `mdbook-preprocessor` crate,
configuration API and renderer-support protocol. The implementation is otherwise
retained, not rewritten.

The repository's existing `Cargo.lock` is unchanged and is used for both
dependency fetching and the build. When intentionally updating Rust dependencies,
check compatibility with the mdBook version in the root nixpkgs lock.

## Licensing

The upstream license is **unknown**. Its manifest declares
`license-file = "LICENSE"`, but that file is absent from the pinned source and
was not found in the upstream history. The manifest entry and original
attributions are retained; no replacement license is inferred.

The imported files are explicitly marked `LicenseRef-Unknown` in `.reuse/dep5`,
overriding the general Unlicense annotation for `src/*`. This is a licensing-status
marker, not a license grant; see `LICENSES/LicenseRef-Unknown.txt` at the repository
root. The Nix package does not assert a license. `reuse lint` deliberately flags
this unknown-license marker; the annotation does not resolve the missing license.

## Validation

Run the protocol smoke test (replace the system when appropriate):

```sh
nix build --no-link './src/data#mdbook-paisano-preprocessor.packages.x86_64-linux.default.tests.mdbook'
```

The smoke test invokes the real mdBook executable, checks HTML renderer support,
installs the embedded CSS assets and verifies that a chapter survives the
preprocessor's JSON protocol. The full
integration test also exercises Nix evaluation and reference generation:

```sh
nix develop .#book -c mdbook build
```

Synchronize private nixpkgs pins after updating the root lock:

```sh
./.github/workflows/update-subflake.sh
```
