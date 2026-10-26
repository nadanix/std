# Registry (`__std`)

The registry connects Nix-organized artifacts to discovery and automation. This
is an **as-is contract description**, observed at [`322921b`][baseline], not a new
compatibility guarantee. Implementation and fixture links cite that revision as
evidence, not the current checkout. The [repository map](../explain/repository-map.md)
provides navigation to maintained sources; the [glossary](../glossary.md) owns the
terms Cell, Cell Block, Block Type, Target and Action.

## Producer and representation

[`grow/default.nix`][grow] imports Blocks and exposes both ordinary outputs and
`__std`. [`newExtractFor.nix`][extract] derives per-Target metadata and actions;
[`newHelpers.nix`][helpers] aggregates them. [`registry.schema.json`][schema]
describes the serialized representation. Nix values and JSON values are not
interchangeable: action values are derivations in Nix, represented as strings
when serialized. A serialized output path is not proof that it has been built.

For each Target, the extractor calls the Block Type's action function, when
present, with `inputs`, `target`, `fragment`, `fragmentRelPath` and `currentSystem`.
`fragment` identifies the system-scoped Target; `fragmentRelPath` is
`cell/block/target`. The action runtime system uses `builtins.currentSystem` when
available (impure evaluation), otherwise the selected output system. Action names
index the returned commands and connect them to discovery and CI records.

| Field                                                     | Observed meaning                                                                                                                                                  |
| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `__std.__schema`                                          | Literal `"v0"`. The schema also declares this constant; it does not by itself establish an evolution policy.                                                      |
| `__std.cellsFrom`                                         | `baseNameOf cellsFrom` from the producer, not the full checkout-relative path. The schema calls it a relative Cell-root path; see the direnv qualification below. |
| `__std.init.<system>`                                     | List of Cells with Blocks, Targets and display/action metadata. Kept separate from action derivations for discovery economy.                                      |
| `__std.actions.<system>.<cell>.<block>.<target>.<action>` | The action's command derivation, selected and built on demand by consumers. This is distinct from the ordinary Target at `<system>.<cell>.<block>.<target>`.      |
| `__std.ci.<system>`                                       | List of CI discovery candidates for configured actions, including derivation paths and optional metadata. Not a record of jobs having run.                        |

### Discovery records (`init`)

These are producer fields, not a replacement schema. `?` means the field may be
absent, not that its value is necessarily `null`.

| Record     | Fields                                                |
| ---------- | ----------------------------------------------------- |
| Cell       | `cell`, `cellBlocks` (list), `readme?`                |
| Cell Block | `cellBlock`, `blockType`, `targets` (list), `readme?` |
| Target     | `name`, `actions` (list), `description?`, `readme?`   |
| Action     | `name`, `description`, `requiresArgs` (boolean)       |

The extractor takes Target descriptions from `target.meta.description` and
computes `requiresArgs` by membership in `target.meta.requiresArgs`, defaulting
to `false`. [`paths.nix`][paths] locates companion readmes; their locations are
already documented in [Conventions](conventions.md#readme-file-locations).
Readme fields refer to files, not inline Markdown content. The schema is less
specific than the producer about some display fields; it is not an exhaustive
statement of consumer expectations.

### CI candidates (`ci`)

[`newExtractFor.nix`][extract] emits:

| Fields                                         | Observed meaning                                                                                                                                                                                            |
| ---------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `cell`, `block`, `blockType`, `name`, `action` | Cell, named Block, generic Block Type, Target name and selected action name.                                                                                                                                |
| `actionDrv`                                    | `command.drvPath` of the action runnable.                                                                                                                                                                   |
| `targetDrv`                                    | `command.targetDrv`, falling back to `target.drvPath`, otherwise `null`. A Target need not be a derivation.                                                                                                 |
| `proviso`                                      | `action.proviso` or `null`, for a consumer's skip/discovery logic. It is not executed by extraction.                                                                                                        |
| `meta`                                         | `action.meta` or `null`, passed through without translation. The schema's string/null restriction conflicts with container publish metadata; see [Q1](../discovery/open-questions.md#q1-ci-metadata-shape). |

The extractor iterates the attribute names of the Block's `ci` set and requires
each to name an existing action; an unknown action raises an evaluation error.
It does not filter entries by their boolean values. A candidate describes work
for an automation consumer to consider, not permission to perform it.

## Observed invariants and limits

- Names join discovery records to the nested action path: `cell` → `cellBlock`
  → Target `name` → Action `name`, with the system selected separately.
- [`types/default.nix`][types] checks Block declarations and uses `attrs any` for
  Target sets. It does not prove that each Target satisfies all assumptions of
  its Block Type. CI extraction checks the selected command as a derivation.
- With `cli = false`, [`grow`][grow] suppresses per-Target extraction for that
  Block, including actions and CI entries. Ordinary outputs remain; the Block's
  discovery record has an empty Target list. This is not a security boundary.
- Blocks without actions can still expose Targets. `functions` and `anything`
  are examples; see [Builtin Block Types](blocktypes.md).
- [`growOn`][grow-on] composes registry lists across Soil layers. Consumers must
  not assume that a registry came from one directory traversal or one layer.

## Consumers and translations

| Consumer                   | Reads and interpretation                                                                                                                                                                                                                              | Boundary/effects                                                                                                                                                                                                                                    |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Go CLI/TUI                 | [`flake/load.go`][go-load] evaluates `init` for the current system; [`load.go`][go-json] decodes into [`data/data.go`][go-data]. Names become `//cell/block/target:action` selectors.                                                                 | [`flake/run.go`][go-run] builds the selected action, creates a state output link and executes it with the project environment. It can select another system explicitly.                                                                             |
| Rust mdBook preprocessor   | [`lib.rs`][rust-lib] evaluates the configured registry plus the current system; [`reference.rs`][rust-schema] deserializes the Cell list and reads companion files. [`book.toml`][book] points it at `.#__std.init` for the `lib` and `std` chapters. | Generates documentation, not action execution. This path performs Nix evaluation and reads files; building the book writes rendered output.                                                                                                         |
| direnv shell library       | [`lib.sh`][direnv-lib] reads `cellsFrom` and builds `actions.<system>.<cell>.<block>.<target>.enter`. It does not select a shell by decoding `init`.                                                                                                  | Evaluates the resulting shell script, maintains profiles in `PRJ_DATA_HOME` and watches selected files. [`README.md`][direnv-readme] documents a local `cellsFrom` override for filtered sources whose basename does not match the checkout layout. |
| GitHub Actions integration | [`ci.yml`][ci-workflow] calls [`std.yml`][std-workflow], which uses external `divnix/std-action/discover@main` and `run@main`. Local jobs consume discovery `hits` for `cli.build`, `shells.build` and `checks.check`.                                | The registry's `ci` is the producer-side automation surface. The external action implementation is not in-tree; these workflows establish the local wiring, not its complete validation, retry or compatibility behavior.                           |

The Go and Rust paths above decode their own shapes without validating the full
JSON Schema or negotiating `__schema`. Successful decoding therefore does not
prove schema conformance. Go reports JSON decoding errors; Rust uses typed
Serde decoding and can fail while rendering referenced files. Nix evaluation or
build failures are separate from those representation failures and from the
outcome of an executed action. The Go runner rejects a `requiresArgs` action
without extra arguments; that is not validation of the arguments' meaning.
No common retry or recovery contract is established by these sources.

## Discovery, building and execution are different

Extraction describes available work. Building an action realizes its executable
and dependencies. Running it performs the action body. Neither a discovery
record nor a built script establishes that the action succeeded or is safe to
retry.

[`_mkCommand.nix`][mkcommand] creates executable shell derivations with shell
syntax/ShellCheck checks and a runtime `PRJ_ROOT` requirement. Its checks concern
the script, not the outcome of its remote operations. Examples of execution
effects include:

- [`containers.publish`][containers]: copies image tags to a remote registry;
  `load` copies to local container storage/daemons.
- [`installables`][installables]: install, upgrade and remove actions modify a
  Nix profile.
- [`devshells.enter`][devshells]: builds/maintains a shell profile and evaluates
  the shell environment.
- [`terra`][terra]: invokes Terraform with a Git-backed state integration;
  `apply` and `destroy` can change infrastructure.

Registry presence is not authorization, an idempotence promise or evidence of
remote success. Inspect the specific action body before treating it as a check.

## Compatibility and evidence

The accepted [system-first decision][adr-system] explains output organization;
it does not specify a registry migration policy. Changes to names, nesting,
field shapes, readme paths or action executables can affect different consumers
independently. The declared `v0` and permissive parts of the schema do not settle
those compatibility expectations: [Q4](../discovery/open-questions.md#q4-registry-evolution-and-compatibility)
records the missing decision, and [Q1](../discovery/open-questions.md#q1-ci-metadata-shape)
records a concrete disagreement.

Existing evidence surfaces have narrower scopes than that policy:

- [`tests/core-grow`][grow-test] records discovery/output shape;
  [`tests/core-soil`][soil-test] exercises hoisting and composition helpers.
- [`tests/bt-blocktypes`][blocktypes-test] snapshots action definitions using
  synthetic Targets, not successful publication or deployment.
- [`src/tests/direnv.nix`][direnv-test] runs syntax, ShellCheck and isolated mocked
  behavior tests; it does not validate a live remote action.
- The preprocessor's [`tests.mdbook` derivation][preprocessor-package] tests the
  mdBook protocol with `multi = []`. It does not generate the real registry's
  reference chapters; that is a separate full-book integration path.

These links identify coverage, not a claim that the checks were run for this
page or that snapshots accept disputed semantics.

[baseline]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93
[grow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/default.nix
[extract]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/newExtractFor.nix
[helpers]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/newHelpers.nix
[schema]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/registry.schema.json
[paths]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/paths.nix
[types]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/types/default.nix
[grow-on]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/grow-on.nix
[go-load]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/cli/flake/load.go
[go-json]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/cli/load.go
[go-data]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/cli/data/data.go
[go-run]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/cli/flake/run.go
[rust-lib]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/mdbook-paisano-preprocessor/src/lib.rs
[rust-schema]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/mdbook-paisano-preprocessor/src/reference.rs
[book]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/book.toml
[direnv-lib]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/direnv/lib.sh
[direnv-readme]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/direnv/README.md
[ci-workflow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/.github/workflows/ci.yml
[std-workflow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/.github/workflows/std.yml
[mkcommand]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/_mkCommand.nix
[containers]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/containers.nix
[installables]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/installables.nix
[devshells]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/devshells.nix
[terra]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/terra.nix
[adr-system]: ../explain/architecture-decision-records/#4-early-select-system-for-conceptual-untangling
[grow-test]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93/tests/core-grow
[soil-test]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93/tests/core-soil
[blocktypes-test]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93/tests/bt-blocktypes
[direnv-test]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/tests/direnv.nix
[preprocessor-package]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/mdbook-paisano-preprocessor/default.nix
