# Built-in Block Type Catalog

## Summary

- Built-in Block Types are the curated artifact type system of `std`.
- Each Block Type owns the stable action surface for one class of targets.
- Additions or renames should update this catalog, `docs/generated/block-types.md`,
  and the architecture manifest.

## Catalog

| Source             | Type name           | Purpose                                                          | Stable actions                                                                     |
| ------------------ | ------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `anything.nix`     | `anything`          | Fallback semantics for arbitrary values.                         | none                                                                               |
| `arion.nix`        | `arion`             | Arion compose jobs.                                              | `up`, `ps`, `stop`, `rm`, `config`, `arion`                                        |
| `containers.nix`   | `containers`        | OCI images built with nix2container.                             | `build`, `print-image`, `publish`, `load`                                          |
| `data.nix`         | `data`              | JSON-serializable data targets.                                  | `write`, `explore`                                                                 |
| `devshells.nix`    | `devshells`         | Development shells.                                              | `build`, `enter`                                                                   |
| `files.nix`        | `files`             | Text data/file targets.                                          | `explore`                                                                          |
| `functions.nix`    | `functions`         | Reusable Nix functions.                                          | none                                                                               |
| `installables.nix` | `installables`      | Packages intended for profile installation and bundling.         | `build`, `install`, `upgrade`, `remove`, `bundle`, `bundleImage`, `bundleAppImage` |
| `kubectl.nix`      | `kubectl`           | Render and apply Kubernetes manifests.                           | `render`, `diff`, `apply`, `explore`                                               |
| `microvms.nix`     | `microvms`          | microvm.nix virtual machines.                                    | `run`, `console`, `microvm`                                                        |
| `namaka.nix`       | `namaka`            | Namaka snapshot test suites.                                     | `eval`, `check`, `review`, `clean`                                                 |
| `nixago.nix`       | `nixago`            | Nixago pebbles for repo files.                                   | `populate`, `explore`                                                              |
| `nixostests.nix`   | `nixostests`        | NixOS VM tests.                                                  | `run`, `audit-script`, `run-vm`, `run-vm+`, `iptables+`, `iptables-`               |
| `nomad.nix`        | `nomadJobManifests` | Nomad job manifests.                                             | `render`, `deploy`, `explore`                                                      |
| `nvfetcher.nix`    | `nvfetcher`         | nvfetcher source updates.                                        | `fetch`                                                                            |
| `pkgs.nix`         | `pkgs`              | Custom package collections without installable action semantics. | none                                                                               |
| `runnables.nix`    | `runnables`         | Executables intended for `run`.                                  | `build`, `run`                                                                     |
| `terra.nix`        | `terra`             | Terraform configurations managed by Terranix.                    | `init`, `plan`, `apply`, `state`, `refresh`, `destroy`, `terraform`                |

## Design rules

- A Block Type should expose a small stable action surface.
- Actions should use domain/user intent names where possible.
- Edge-tool detail should stay inside the Block Type or an integration library.
- Optional vertical tool dependencies should be documented in
  `dependency-contracts.md`.
- New Block Types should include docs and tests or a clear plan for both.

## Review questions

- Is this a new artifact type or just a target-specific helper?
- Does the Block Type own a reusable action surface?
- Which dependencies or edge tools does it shield?
- Does the target contract need validation or a stable failure envelope?

## Related docs

- `action-runtime.md`
- `dependency-contracts.md`
- `docs/reference/blocktypes.md`
- `docs/generated/block-types.md`
