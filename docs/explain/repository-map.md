# Repository map

Standard turns Nix code organization into discoverable artifacts and actions for
people, tools and CI. Its purpose and SDLC scope belong in
[Design & Architecture](../ARCHITECTURE.md); terminology belongs in the
[glossary](../glossary.md). This page maps that model to the implementation, not
to a new set of architectural decisions.

**View:** as-is. Implementation observations below were checked against
[`322921b`][baseline], not established as future compatibility guarantees.
Source links navigate `main`; use the named paths when working in a different
checkout. Historical evidence and unsettled meaning are recorded in
[open questions](../discovery/open-questions.md).

## From organization to outputs

```text
cellsFrom + named Cell Blocks / Block Types + inputs / systems
    -> grow: discover, import, extract
        -> system.cell.block.target       (ordinary Nix outputs)
        -> __std.init / actions / ci       (discovery and action registry)
    -> growOn: compose Soil layers        (including compatibility outputs)
```

1. **Declare and discover.** A Cell groups related functionality; its directory
   is not automatically a DDD bounded context or an ownership assignment.
   [Architecture](../ARCHITECTURE.md#paisano-code-organization) leaves layout
   semantics to the consumer. [`newProcessCfg.nix`][process] selects the declared
   Block names, keeps the first declaration of a duplicate name and validates
   systems. [`types/cell.nix`][cell-type] requires every entry under `cellsFrom`
   to be a directory with at least one declared Block.
2. **Import.** [`grow/default.nix`][grow] implements the file precedence in
   [Conventions](../reference/conventions.md#nix-file-locations).
   [`newImportSignatureFor.nix`][signature] prepares system-scoped inputs,
   instantiated Nixpkgs and references to other Cells. `inputs.self` contains
   source information, not the full output flake; the importer supplies the
   current Cell as `cell`. A Cell's optional `flake.nix` supplies additional
   inputs through `call-flake`. The function interface is an accepted decision
   in [ADR 0002][adr-interface]; the importer's additional attrset support remains
   [an open question](../discovery/open-questions.md#q2-cell-block-functions-and-attribute-sets).
3. **Expose artifacts and actions.** Outputs are `system.cell.block.target`,
   following [ADR 0004][adr-system]. A Block Type supplies shared actions, not an
   exhaustive proof of each Target's type: [`types/default.nix`][types] checks
   Targets with `attrs any`. The [`functions`][functions] and [`anything`][anything]
   Block Types have no actions. [`newExtractFor.nix`][extract] produces the
   [registry](../reference/registry.md) alongside ordinary outputs.
4. **Compose compatibility outputs.** [`grow-on.nix`][grow-on] recursively merges
   successive Soil layers and combines registry `init` and `ci` lists.
   [`harvest`][harvest] hoists selected paths while preserving the system axis;
   [`winnow`][winnow] adds filtering. [`pick`][pick] removes that axis by selecting
   the first system in attribute-name order; it does not establish equality
   across systems. Soil is where outputs such as `packages` and `devShells` can
   be adapted to other tools, not a second Cell model.

## Physical responsibilities and dependencies

This is a responsibility map, not an inventory. Directories alone do not confer
semantic ownership.

| Location                                                                     | Responsibility and dependency boundary                                                                                                                                                                               |
| ---------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`src/std/core/`][core]                                                      | Discovery, import signatures, registry extraction, validation and Soil helpers. An in-tree Nix library with explicit `nosys`, `call-flake`, `yants` and Nix library dependencies; not a separate flake.              |
| [`src/std/fwlib.nix`][fwlib] and `src/std/fwlib/`                            | Bootstrap the core separately, load framework helpers through Haumea and provide Standard's Block Types and action implementations. Optional integrations are wired through inputs, not supplied by the core itself. |
| [`src/lib/`][lib] and [`src/data/`][data]                                    | Reusable development/operations helpers and configuration data. The data Cell also provides the local documentation preprocessor package.                                                                            |
| [`src/std/cli/`][cli]                                                        | Go CLI/TUI: decode discovery metadata, present Targets and build/execute selected actions. [`src/std/cli.nix`][cli-package] packages it as `std`.                                                                    |
| [`src/std/direnv/`][direnv]                                                  | Shell adapter: select the devshell `enter` action, manage profiles and watch files. Depends on direnv and the pinned `numtide/prj-spec` helper, not on the Go UI.                                                    |
| [`src/data/mdbook-paisano-preprocessor/`][preprocessor]                      | Rust consumer of discovery metadata; renders Cell reference chapters. [`src/data/flake.nix`][data-flake] builds it from local sources with Nixpkgs.                                                                  |
| [`src/local/`][local], [`src/tests/`][tests-cell] and [`tests/`][tests]      | This repository's own development configuration and validation, rather than the framework's discovery engine.                                                                                                        |
| [`docs/SUMMARY.md`][summary], [`book.toml`][book] and [workflows][workflows] | Book navigation, registry-backed documentation generation and direct Linux CI checks. See the [current gates](../guides/contributing.md#existing-automation-and-gates).                                              |

The fork's current CI selects checks and snapshots directly, without external
`divnix/std-action` orchestration or publication. This replaces the inherited
workflow wiring at the cited baseline, not the framework's registry interface.

Core, CLI and preprocessor retain Paisano names and provenance in their linked
READMEs. Those names do not make them external flake dependencies. In particular,
the Go module's Paisano import path resolves to local sources. The preprocessor's
[licensing status](../discovery/open-questions.md#q3-preprocessor-licensing) is not
settled by its inclusion here.

## Framework bootstrap versus dogfooding

[`flake.nix`][flake] constructs the consumable framework before using it to
assemble this repository:

1. Import `src/std/fwlib.nix` directly, with bootstrap inputs and an empty `cell`.
2. Load `fwlib` again through `grow`, then `pick`, to enable input overloading for
   Block Types. Export the framework tools, including `grow`, `growOn`, Soil
   helpers and `blockTypes`.
3. Pass those tools into [`dogfood.nix`][dogfood]. It grows the `local` and `tests`
   Cells with their private inputs and the current Standard source, then grows
   the downstream-facing `std`, `lib` and `data` Cells. Soil assembles conventional
   outputs such as `devShells`, `checks`, `packages` and `templates`.

Thus the same checkout is both a framework implementation and a consumer of that
framework. A local shell/configuration change is not inherently a core change.
The root flake declares optional integration inputs through `blank`/`follows`;
private Cell inputs provide concrete integrations for dogfooding. Dependency
maintenance is described in the existing [Devshells note][shells], not here.
[ADR 0006][adr-overlays] remains the decision on avoiding framework-level overlay
support; the physical bootstrap does not replace it.

## Follow a boundary, not the whole repository

- For **Target discovery or action execution**, continue with the
  [registry contract](../reference/registry.md), then the specific producer or
  consumer linked there. Discovery, building and execution are distinct steps.
- For **bootstrap and private-input isolation**, start with `flake.nix` and
  `dogfood.nix`; [`tests/dogfood/expr.nix`][dogfood-test] checks source/provider and
  pin relationships. [`tests/fork-identity/expr.nix`][identity-test] checks fork
  identity while preserving external integration names.
- For **discovery and Soil behavior**, see [`tests/core-grow`][grow-test] and
  [`tests/core-soil`][soil-test]. These are snapshot fixtures, not evidence of
  remote action effects or acceptance of disputed semantics.
- For **unresolved contracts or authority**, use
  [open questions](../discovery/open-questions.md), rather than inferring a
  decision from the directory tree or a passing snapshot.

[baseline]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93
[summary]: https://github.com/nadanix/std/blob/main/docs/SUMMARY.md
[adr-interface]: architecture-decision-records/#2-restrict-the-calling-interface
[adr-system]: architecture-decision-records/#4-early-select-system-for-conceptual-untangling
[adr-overlays]: architecture-decision-records/#6-avoid-fix-point-logic-such-as-overlays
[process]: https://github.com/nadanix/std/blob/main/src/std/core/grow/newProcessCfg.nix
[cell-type]: https://github.com/nadanix/std/blob/main/src/std/core/types/cell.nix
[grow]: https://github.com/nadanix/std/blob/main/src/std/core/grow/default.nix
[signature]: https://github.com/nadanix/std/blob/main/src/std/core/grow/newImportSignatureFor.nix
[types]: https://github.com/nadanix/std/blob/main/src/std/core/types/default.nix
[functions]: https://github.com/nadanix/std/blob/main/src/std/fwlib/blockTypes/functions.nix
[anything]: https://github.com/nadanix/std/blob/main/src/std/fwlib/blockTypes/anything.nix
[extract]: https://github.com/nadanix/std/blob/main/src/std/core/grow/newExtractFor.nix
[grow-on]: https://github.com/nadanix/std/blob/main/src/std/core/grow/grow-on.nix
[harvest]: https://github.com/nadanix/std/blob/main/src/std/core/soil/harvest.nix
[winnow]: https://github.com/nadanix/std/blob/main/src/std/core/soil/winnow.nix
[pick]: https://github.com/nadanix/std/blob/main/src/std/core/soil/pick.nix
[core]: https://github.com/nadanix/std/blob/main/src/std/core/README.md
[fwlib]: https://github.com/nadanix/std/blob/main/src/std/fwlib.nix
[lib]: https://github.com/nadanix/std/tree/main/src/lib
[data]: https://github.com/nadanix/std/tree/main/src/data
[cli]: https://github.com/nadanix/std/blob/main/src/std/cli/README.md
[cli-package]: https://github.com/nadanix/std/blob/main/src/std/cli.nix
[direnv]: https://github.com/nadanix/std/blob/main/src/std/direnv/README.md
[preprocessor]: https://github.com/nadanix/std/blob/main/src/data/mdbook-paisano-preprocessor/README.md
[data-flake]: https://github.com/nadanix/std/blob/main/src/data/flake.nix
[local]: https://github.com/nadanix/std/tree/main/src/local
[tests-cell]: https://github.com/nadanix/std/tree/main/src/tests
[tests]: https://github.com/nadanix/std/tree/main/tests
[book]: https://github.com/nadanix/std/blob/main/book.toml
[workflows]: https://github.com/nadanix/std/tree/main/.github/workflows
[flake]: https://github.com/nadanix/std/blob/main/flake.nix
[dogfood]: https://github.com/nadanix/std/blob/main/dogfood.nix
[shells]: https://github.com/nadanix/std/blob/main/src/local/shells.md
[dogfood-test]: https://github.com/nadanix/std/blob/main/tests/dogfood/expr.nix
[identity-test]: https://github.com/nadanix/std/blob/main/tests/fork-identity/expr.nix
[grow-test]: https://github.com/nadanix/std/tree/main/tests/core-grow
[soil-test]: https://github.com/nadanix/std/tree/main/tests/core-soil
