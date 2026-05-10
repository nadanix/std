# std Domain Model

## Summary

- `std` is a horizontal integration framework for typed DevOps artifacts.
- The core model is `Cell -> Cell Block -> Target -> Action`.
- `std` now owns the Paisano-derived importer and registry abstractions as
  absorbed internal components, alongside curated SDLC semantics, defaults, and
  built-in Block Types.
- The model includes a Paisano-derived component view: config processing, path
  discovery, import-signature construction, target extraction, registry lanes,
  soil translation, CLI/TUI consumption, and mdBook reference generation.
- The main design goal is agent and human legibility: a repo should answer
  "what can I do here?" through structure and discoverable metadata.

## Scope

This document models `std` itself and the Paisano-derived components that form
its importer, registry, soil, CLI/TUI, and mdBook-reference seams. These sources
are absorbed into this repository, but the model still treats the public `std`
API and `#__std` registry as the stable contract rather than exposing every
implementation file as public API. It does not redefine the generic design
framework in `docs/vendor/design-context/`, and does not replace the historical
narrative in root `ARCHITECTURE.md`.

## Ubiquitous language

| Term                   | Meaning in `std`                                                                            | Notes                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Cell                   | First-level grouping under `cellsFrom`; a coherent collection of functionality.             | Project-specific semantics are chosen by the consumer repo.                           |
| Cell Block             | Named block inside a Cell that represents a class of outputs.                               | Implemented as `<block>.nix` or `<block>/default.nix`.                                |
| Block Type             | Generic type for a Cell Block; may provide actions.                                         | Examples: `installables`, `devshells`, `containers`.                                  |
| Target                 | Concrete output inside a Cell Block.                                                        | `default` is the conventional singleton target.                                       |
| Action                 | Runnable procedure provided by a Block Type for a Target.                                   | Examples: `build`, `run`, `enter`, `publish`.                                         |
| Registry               | `#__std`, the discoverable metadata surface consumed by CLI/TUI/CI.                         | Produced by the absorbed Paisano core and shaped by `std` configuration.              |
| Registry lane          | One logical slice of the registry produced during import.                                   | The absorbed core emits `actions`, `init`, and `ci` lanes plus schema data.           |
| Import signature       | The argument contract used to import a Cell Block.                                          | The absorbed core constructs it; Cell Blocks receive `{ inputs, cell }`.              |
| Extractor              | Component that turns targets into registry metadata and action derivations.                 | Keeps registry discovery separate from raw target values.                             |
| grow                   | Import and type a project using Standard defaults, returning the std-shaped output graph.   | Removes the `growOn` functor surface.                                                 |
| growOn                 | Import and type a project while allowing additional flake-output soil.                      | Used when layering compatibility outputs.                                             |
| harvest                | Translate std-shaped outputs into Nix CLI-compatible flake outputs.                         | Lossy by design when the target schema is less expressive.                            |
| pick                   | Select std outputs while removing system scope where appropriate.                           | Useful for system-agnostic outputs such as templates.                                 |
| winnow                 | Select std outputs with predicates.                                                         | Used when filtering targets from the std graph.                                       |
| Soil                   | Compatibility layer around the std graph.                                                   | Keeps downstream Nix CLI or flake-parts expectations outside the core model.          |
| Input overloading      | Replacing default `blank` inputs with real vertical-tool integrations.                      | Missing integrations should fail through `requireInput`.                              |
| Dogfood input manifest | A self-hosting subflake that declares private repo-local inputs without depending on `std`. | The root flake loads these manifests and injects a dogfood `std` instance explicitly. |
| PRJ env                | Runtime environment satisfying prj-spec variables such as `PRJ_ROOT`.                       | Required by Block Type actions.                                                       |

## Aggregate sketch

```text
StdProject
  inputs
  systems
  cellsFrom
  cellBlocks
  paisanoCore
  registry
  harvestedOutputs
```

```text
PaisanoCore
  typeContracts
  pathConventions
  configProcessor
  growImporter
    importSignatureBuilder
    cellBlockLoader
    targetExtractor
    registryBuilder
  soilTranslators
  registrySchema
```

```text
PaisanoTui
  registryLoader
  metadataCache
  selectorParser
  actionResolver
  actionRunner
  prjEnvironmentAdapter
```

### Entities

- `Cell`
- `CellBlock`
- `Target`
- `Action`
- `Registry`
- `RegistryLane`
- `PaisanoImporter`
- `PaisanoRegistryConsumer`
- `SoilTranslator`
- `ToolInput`

### Value objects

- `BlockTypeSpec`
- `Selector`, for example `//cell/block/target:action`
- `HarvesterPath`
- `CurrentSystem`
- `InputContract`
- `ImportSignature`
- `PathConvention`
- `ActionMetadata`
- `FailureEnvelope`

## Paisano-derived internal component model

`std` carries the artifact importer and registry production code that originated
in Paisano. The following component view is part of the `std` model because it
defines the stable seams that `std` wraps, documents, and tests. The
implementation is internal, but downstream consumers should still bind only to
the public `std` facade and registry contract.

| Component                           | Local source area                                              | Purpose in the model                                                                              | `std` seam                                                                                         |
| ----------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Type contracts                      | `src/std/_sources/paisano-core/types/`                         | Validate Cell, Cell Block, Block Type, Target, and Action Command shapes.                         | `std.blockTypes.*` must produce valid Block Type specs and action commands.                        |
| Path conventions                    | `src/std/_sources/paisano-core/paths.nix`                      | Map `cellsFrom` to Cells, Cell Blocks, target docs, and README metadata.                          | Downstream repos use `<cell>/<block>.nix` or `<cell>/<block>/default.nix`.                         |
| Config processor                    | `src/std/_sources/paisano-core/grow/newProcessCfg.nix`         | Normalize systems, deduplicate Cell Blocks, and discover Cells.                                   | `std.grow` and `std.growOn` pass curated defaults before the absorbed core validates the contract. |
| Import-signature builder            | `src/std/_sources/paisano-core/grow/newImportSignatureFor.nix` | De-systemize inputs, instantiate `nixpkgs`, inject `inputs.cells`, and source metadata.           | Cell Blocks keep the small `{ inputs, cell }` interface.                                           |
| Cell Block loader                   | `src/std/_sources/paisano-core/grow/default.nix`               | Load existing block files/directories per system and assemble the output graph.                   | `std` relies on the absorbed core for recursion, optional block loading, and graph shape.          |
| Target extractor / registry builder | `src/std/_sources/paisano-core/grow/newExtractFor.nix`         | Materialize actions and extract `actions`, `init`, and `ci` registry lanes.                       | CLI/TUI, CI, and agents consume registry metadata instead of scraping the source tree.             |
| Accumulator helpers                 | `src/std/_sources/paisano-core/grow/newHelpers.nix`            | Merge output, action, init, and CI lanes while skipping absent blocks.                            | Sparse Cells are valid as long as declared Block Types are the only import candidates.             |
| Soil translators                    | `src/std/_sources/paisano-core/soil/{winnow,harvest,pick}.nix` | Translate `system.cell.block.target` into Nix-flake-compatible output shapes.                     | `std.harvest`, `std.pick`, and `std.winnow` keep compatibility outside the core artifact model.    |
| Registry schema                     | `src/std/_sources/paisano-core/registry.schema.json`           | Version the JSON-serializable `#__std` contract.                                                  | External consumers should bind to the schema, not to importer internals.                           |
| Paisano TUI/CLI                     | `src/std/_sources/paisano-tui`                                 | Load registry metadata, cache it, parse selectors, build action derivations, and execute actions. | `std` packages and brands this consumer as the `std` command.                                      |
| mdBook Paisano preprocessor         | `src/std/_sources/mdbook-paisano-preprocessor`                 | Append Cell reference documentation from `#__std.init` into mdBook chapters.                      | Documentation config keeps the `paisano-preprocessor` name stable for now.                         |

### Paisano component flow

```text
std.grow / std.growOn configuration
  -> Paisano config processor
  -> per-system import signature
  -> Cell and Cell Block path discovery
  -> Cell Block loader
  -> Target extractor
  -> registry lanes: __std.actions, __std.init, __std.ci
  -> std-shaped output graph
  -> optional soil translation through winnow / harvest / pick
  -> Paisano TUI/CLI or CI consumes registry selectors and action derivations
```

### Paisano ownership rules

- Treat the component names above as an internal architecture map, not as a
  public implementation API.
- Bind downstream `std` behavior to exported contracts: `grow`, `growOn`,
  `harvest`, `pick`, `winnow`, registry shape, and selector/action semantics.
- Keep curated SDLC meaning in `std` Block Types and `std.lib.*`; keep import,
  registry, selector, and mdBook-generation mechanics behind narrow adapters.
- If `std` starts depending on a behavior not captured here, update this model
  and `dependency-contracts.md` in the same change.

## Invariants

- Cell Blocks expose only `{ inputs, cell }` as their entry interface.
- Block Types own action definitions for their target class.
- Tool-specific details are translated at Block Type or library edges.
- Optional integrations are absent by default and activated through input
  overloading.
- Dogfood-only inputs live in private input manifests and are injected by the
  root flake; those manifests must not self-reference the in-repo `std` flake.
- Actions run through a small, stable runtime contract rather than ad hoc shell
  snippets.
- The registry is the machine-facing system of record for actionable repo
  targets.
- Paisano-derived component behavior remains internal unless surfaced through
  exported `std` contracts.
- Soil translation is a compatibility edge and should not become the core model.

## Context relationships

| Relationship                          | Shape                                                                                                  |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| `std` -> absorbed Paisano core        | Internal component. `std` owns importer, type checks, path conventions, registry, and soil primitives. |
| `std` -> importer components          | Component seam for config processing, import signatures, loading, extraction, and registry lanes.      |
| `std` -> absorbed Paisano TUI         | CLI/TUI packaging and branding seam. `std` packages the TUI as the `std` command.                      |
| `std` -> absorbed mdBook preprocessor | Documentation generation seam. `std` appends Cell reference docs from `#__std.init`.                   |
| `std` -> Nix CLI flake schema         | Translation seam via `harvest`, `pick`, and `winnow`.                                                  |
| `std` -> vertical tools               | Shielding edge contexts through Block Types and `std.lib.*`.                                           |
| consumer repo -> `std`                | Shared vocabulary by agreement: Cells, Cell Blocks, Targets, and Actions.                              |

## Review questions

- Is a new concept part of the core artifact model, the curated std facade, or a
  vertical-tool adapter?
- Does the change preserve the `Cell -> Cell Block -> Target -> Action` mental
  model?
- Does an agent learn the right next file from maps/manifests instead of hidden
  human context?
- Is a failure represented through a stable envelope instead of leaking raw tool
  detail inward?
- If the change touches Paisano behavior, is it relying on an exported contract
  or on internal mechanics that need a new contract/test?

## Related docs

- `bounded-contexts.md`
- `dependency-contracts.md`
- `workflows.md`
- `docs/glossary.md`
- `ARCHITECTURE.md`
