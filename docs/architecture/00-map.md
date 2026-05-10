# std Architecture Map

This directory is the agent-facing architecture surface for `std`.

## Default load order

1. `std-domain-model.md`
2. `bounded-contexts.md`
3. `dependency-contracts.md`
4. the smallest relevant workflow, invariant, or catalog doc
5. root `ARCHITECTURE.md` only when historical rationale is needed

## Documents

| Document                  | Load when                                                                                                             |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `std-domain-model.md`     | You need the ubiquitous language, aggregate shape, absorbed Paisano component view, or dogfood input model of `std`.  |
| `bounded-contexts.md`     | You are changing ownership boundaries or deciding where behavior belongs.                                             |
| `dependency-contracts.md` | You touch flake inputs, dogfood private manifests, Paisano/Divnix dependencies, or vertical tool integrations.        |
| `workflows.md`            | You change `grow`, harvesting, dogfood input injection, action invocation, optional integrations, or docs generation. |
| `action-runtime.md`       | You change action scripts, `mkCommand`, PRJ env assumptions, or action failure behavior.                              |
| `block-type-catalog.md`   | You add, rename, remove, or review a built-in Block Type.                                                             |
| `invariants.md`           | You need the architecture and taste rules that should stay mechanically enforceable.                                  |
| `quality-score.md`        | You want a compact review of current architecture/documentation gaps.                                                 |

## Manifests

- `docs/manifests/architecture-manifest.yaml`
- `docs/manifests/dependency-contracts-manifest.yaml`

## Related docs

- `docs/00-map.md`
- `ARCHITECTURE.md`
- `docs/glossary.md`
- `docs/vendor/design-context/context/principles/01-information-architecture-and-manifests.md`
- `docs/vendor/design-context/context/patterns/01-boundary-and-decomposition-patterns.md`
