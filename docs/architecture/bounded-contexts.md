# std Bounded Contexts

## Summary

- `std` is best understood as several semantic contexts around one artifact
  model.
- `std` owns the absorbed Paisano-derived importer and registry abstractions.
- `std` also owns curated DevOps semantics, built-in Block Types, action runtime,
  and integration adapters.
- The repo dogfoods `std`, but dogfood automation is not the same context as the
  downstream framework surface.

## Context cards

### Absorbed Paisano Artifact Model

| Field          | Description                                                               |
| -------------- | ------------------------------------------------------------------------- |
| Purpose        | Import repo structure into typed artifacts and expose a registry.         |
| Strategic role | Internal core framework component.                                        |
| Vocabulary     | Cell, Cell Block, Block Type, Target, Registry.                           |
| Owns           | Importer behavior, registry shape, `growOn`, `harvest`, `pick`, `winnow`. |
| Does not own   | `std`'s curated SDLC defaults or built-in Block Type catalog.             |
| Relationship   | Internal contract behind the public `std` facade.                         |

### Standard Framework Facade

| Field          | Description                                                                             |
| -------------- | --------------------------------------------------------------------------------------- |
| Purpose        | Present the public `std` API and keep downstream flakes small and legible.              |
| Strategic role | Core differentiator.                                                                    |
| Vocabulary     | `grow`, `growOn`, `blockTypes`, `actions`, `dataWith`, `flakeModule`.                   |
| Owns           | Defaults, public exports, bootstrap/dogfood layering, compatibility surface.            |
| Does not own   | Vertical tool semantics.                                                                |
| Relationship   | Translation seam between absorbed importer mechanics, Nix flakes, and downstream users. |

### Block Type Catalog

| Field          | Description                                                                             |
| -------------- | --------------------------------------------------------------------------------------- |
| Purpose        | Curate artifact classes and common actions for SDLC automation.                         |
| Strategic role | Core differentiator.                                                                    |
| Vocabulary     | Installable, runnable, devshell, container, data, file, nixago pebble, deploy manifest. |
| Owns           | Built-in Block Type definitions and action lists.                                       |
| Does not own   | The internal implementation of each target's artifact.                                  |
| Relationship   | Single decision owner for built-in action semantics.                                    |

### Action Runtime

| Field          | Description                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------- |
| Purpose        | Turn action definitions into executable commands with a stable environment and failure surface. |
| Strategic role | Supporting capability.                                                                          |
| Vocabulary     | `mkCommand`, dependency list, proviso, PRJ env, action metadata.                                |
| Owns           | Shell strictness, PRJ env check, dependency PATH injection, shellcheck/dry-run checks.          |
| Does not own   | Business meaning of vertical tools such as Terraform, Nomad, or Kubernetes.                     |
| Relationship   | Stable failure envelope and execution adapter for all actions.                                  |

### Integration Libraries

| Field          | Description                                                        |
| -------------- | ------------------------------------------------------------------ |
| Purpose        | Provide reusable dev, ops, and cfg adapters around vertical tools. |
| Strategic role | Supporting capability.                                             |
| Vocabulary     | `mkShell`, `mkNixago`, `mkOCI`, `mkOperable`, config pebble.       |
| Owns           | Translation from std conventions to vertical-tool APIs.            |
| Does not own   | Upstream tool internals.                                           |
| Relationship   | Shielding edge context.                                            |

### CLI/TUI Experience

| Field          | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| Purpose        | Let humans and agents discover and run repo actions from the registry. |
| Strategic role | Core user experience.                                                  |
| Vocabulary     | selector, action, target, registry, completion.                        |
| Owns           | Absorbed TUI source, packaging as `std`, branding, shell completions.  |
| Does not own   | Registry production details beyond the public `#__std` contract.       |
| Relationship   | Consumer of registry outcomes.                                         |

### Consumer Project Model

| Field          | Description                                                             |
| -------------- | ----------------------------------------------------------------------- |
| Purpose        | A downstream repo declares its automation using Cells and Cell Blocks.  |
| Strategic role | External consumer context.                                              |
| Vocabulary     | Project-specific Cells and Targets plus shared std vocabulary.          |
| Owns           | Local semantics, naming, target implementations, compatibility outputs. |
| Does not own   | Built-in std Block Type behavior.                                       |
| Relationship   | Shared vocabulary by agreement.                                         |

### Self-hosting / Dogfood

| Field          | Description                                                                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Purpose        | Use `std` to build, test, document, and maintain `std` itself.                                                                                       |
| Strategic role | Internal validation context.                                                                                                                         |
| Vocabulary     | `local`, `tests`, snapshots, configs, devshell.                                                                                                      |
| Owns           | This repo's development environment, test wiring, and private dogfood input manifests.                                                               |
| Does not own   | Downstream framework semantics or public optional-input defaults.                                                                                    |
| Relationship   | Split by change pressure from the public framework surface; the root flake injects dogfood inputs instead of having subflakes lock the parent `std`. |

## Boundary rules

- Do not leak absorbed Paisano implementation details into downstream std docs unless the
  contract requires it.
- Do not let vertical tool vocabulary replace std's artifact vocabulary.
- Keep dogfood-only concerns out of the downstream framework API.
- Treat dogfood input manifests as a self-hosting boundary: they declare private
  inputs, while the root framework facade owns injecting the appropriate `std`
  instance.
- Keep `AGENTS.md` as a map; put durable context-specific knowledge here.

## Review questions

- Which context owns the decision being changed?
- Is the seam internal, shared vocabulary, or anti-corruption?
- Could a downstream repo understand the change without reading dogfood code?
- Could absorbed Paisano-derived internals evolve without forcing downstream docs to change?

## Related docs

- `std-domain-model.md`
- `dependency-contracts.md`
- `block-type-catalog.md`
- `docs/vendor/design-context/context/patterns/01-boundary-and-decomposition-patterns.md`
