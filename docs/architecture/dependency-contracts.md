# Dependency Contracts

## Summary

- Treat flake inputs as context contracts, not as a flat dependency list.
- Paisano-derived importer, registry, CLI/TUI, and mdBook preprocessor code is being absorbed into this repo.
- Divnix-family inputs mostly provide small semantic utilities or temporary implementation helpers used by `std`.
- Vertical tool inputs are optional edge integrations and should be shielded
  behind Block Types or `std.lib.*`.
- If a dependency is not legible to agents from this repo, document the contract
  or hide it behind a smaller adapter.

## Contract groups

### Paisano family

| Input                                                                        | Relationship                                | std consumes                                                                                | std owns                                                |
| ---------------------------------------------------------------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| Paisano core (`src/std/_sources/paisano-core`)                               | Absorbed internal framework component.      | Local source for `growOn`, `harvest`, `pick`, `winnow`, registry and artifact abstractions. | Public std facade, defaults, curated Block Types.       |
| Paisano TUI (`src/std/_sources/paisano-tui`)                                 | Absorbed registry consumer packaged by std. | Local Go source for CLI/TUI.                                                                | Binary name `std`, version/branding flags, completions. |
| mdBook Paisano preprocessor (`src/std/_sources/mdbook-paisano-preprocessor`) | Absorbed docs edge adapter.                 | Local Rust source for mdBook preprocessing from `#__std.init`.                              | Documentation layout and inclusion policy.              |

### Documentation tool compatibility pins

| Source                                      | Relationship                                 | Purpose in std                                    | Boundary note                                                            |
| ------------------------------------------- | -------------------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------ |
| `nixpkgs/nixos-25.05#mdbook`                | Tool protocol compatibility pin.             | Provides mdBook 0.4 for `std.lib.cfg.mdbook`.     | Required until `mdbook-paisano-preprocessor` supports mdBook 0.5+ input. |
| local `mdbook-paisano-preprocessor` package | Absorbed Paisano documentation edge adapter. | Generates Cell reference docs from `#__std.init`. | Keep paired with a compatible mdBook preprocessor protocol.              |

### Divnix and Nix ecosystem core

| Input                 | Relationship                     | Purpose in std                                          | Boundary note                                            |
| --------------------- | -------------------------------- | ------------------------------------------------------- | -------------------------------------------------------- |
| `yants`               | Validation dependency.           | Type checks for framework contracts.                    | Keep checks close to public contract surfaces.           |
| `dmerge`              | Policy utility.                  | Merge config data and Nixago pebbles.                   | Avoid turning merge behavior into hidden global policy.  |
| `blank`               | Optional-input sentinel.         | Placeholder for integrations not loaded by default.     | Missing integrations should fail through `requireInput`. |
| `call-flake`          | Temporary importer helper.       | Load per-Cell `flake.nix` inputs for input overloading. | Keep isolated behind the absorbed Paisano core adapter.  |
| `nosys`               | Temporary de-systemizing helper. | Hide system scope from Cell Block inputs.               | Keep isolated behind the absorbed Paisano core adapter.  |
| `haumea`              | Loader infrastructure.           | Load framework library files.                           | Internal implementation detail.                          |
| `lib` (`nixpkgs.lib`) | Library substrate.               | System-independent Nix library.                         | Prefer this when full `nixpkgs` is not required.         |
| `nixpkgs`             | Build and package substrate.     | Packages, shell tooling, lib, stdenv.                   | Special, but not a license to add hidden global context. |
| `nixpkgs.lib.fileset` | Source boundary helper.          | Filter source trees for `cellsFrom` and package srcs.   | Prefer native file sets; `std.incl` is deprecated.       |

### Optional vertical tool integrations

| Input      | Relationship                                  | std surface                                                                | Expected failure when absent                      |
| ---------- | --------------------------------------------- | -------------------------------------------------------------------------- | ------------------------------------------------- |
| `devshell` | Shielded development-environment integration. | `std.lib.dev.mkShell`, `devshells` workflows.                              | `requireInput "devshell" ...`                     |
| `nixago`   | Shielded repo-file generation integration.    | `std.lib.dev.mkNixago`, `nixago` Block Type, cfg pebbles.                  | `requireInput "nixago" ...`                       |
| `n2c`      | Shielded OCI integration.                     | `containers` Block Type, `std.lib.ops.mkOCI`, `mkDevOCI`, `mkStandardOCI`. | `requireInput "n2c" ...`                          |
| `terranix` | Terraform config generator.                   | `terra` Block Type.                                                        | Action should surface missing tool/input clearly. |
| `microvm`  | MicroVM integration.                          | `microvms` Block Type, `std.lib.ops.mkMicrovm`.                            | `requireInput "microvm" ...`                      |
| `makes`    | Fluidattacks Makes integration.               | `std.lib.dev.mkMakes`.                                                     | `requireInput "makes" ...`                        |
| `arion`    | Compose/orchestration integration.            | `arion` Block Type, `std.lib.dev.mkArion`.                                 | `requireInput "arion" ...`                        |
| `namaka`   | Snapshot testing integration.                 | `namaka` Block Type and this repo's tests.                                 | Missing input breaks snapshot actions.            |

### Test and downstream compatibility inputs

| Input                                                  | Scope                                    | Note                                                                             |
| ------------------------------------------------------ | ---------------------------------------- | -------------------------------------------------------------------------------- |
| `flake-parts`                                          | Test subflake / compatibility examples.  | Used to validate flake-parts integration, not as the core std composition model. |
| `arion`, `microvm`, `makes`, `terranix` in `src/tests` | Test coverage for optional integrations. | Keep these scoped to tests unless they become required framework inputs.         |

## Boundary policies

1. Prefer a small adapter over leaking a large upstream API into `std` docs.
2. Prefer `requireInput` for optional input failures so the remediation is
   stable and agent-readable.
3. Record new direct inputs here in the same PR that adds them.
4. If an input changes the public model, update `std-domain-model.md` or an ADR.
5. If an input only supports this repo's local development, keep it in dogfood
   docs rather than the downstream framework surface.

## Review questions

- Is this dependency core, supporting, optional, or test-only?
- Which context owns the contract shape?
- What does `std` consume, and what does it deliberately hide?
- What failure should an agent see if the dependency is missing or blanked out?
- Does the dependency increase agent legibility or require compensating docs?

## Related docs

- `bounded-contexts.md`
- `action-runtime.md`
- `invariants.md`
- `docs/manifests/dependency-contracts-manifest.yaml`
