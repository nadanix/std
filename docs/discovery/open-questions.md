# Open questions

This page tracks unresolved questions and explicitly scoped decisions about the
implementation and its contracts. The original static review was checked against
[`322921b`][baseline]. The later
[nine-scenario review](scenario-review.md), at `d0f1c75`, adds bounded evidence
for Q1/Q2/Q4 and preserves scenario-specific questions below. Its discovery
closure was accepted on 2026-10-26, not its unresolved contracts. The
[repository map](../explain/repository-map.md) provides orientation and the
[registry reference](../reference/registry.md) describes the observed boundary.

Knowledge status is separate from resolution status: `observed` means a cited
artifact contains the evidence; `disputed` means relevant sources disagree;
`inferred` is a conclusion still needing validation; `unknown` marks missing
knowledge. `confirmed` is reserved for acceptance by an accountable validator
within a stated scope, not for agreement between code and a snapshot.

Q1 now records a local shape decision; its external compatibility review remains
**open**, as do the other questions. Validation owners for the remaining questions
have not been assigned; roles listed below identify perspectives needed, not
people who have accepted responsibility. Maintainer, downstream-consumer and
upstream licensing perspectives are not replaced by this source review.

## Q1. CI metadata shape

**Resolution status:** local shape decision accepted on 2026-10-27; external
compatibility validation remains open.

**Knowledge status:** `observed` historical producer/schema discrepancy and
bounded jq behavior; external consumer compatibility is not confirmed.

**Historical evidence at the cited revisions:**

- [`registry.schema.json`][schema], `definitions.ci` → candidate `meta`, permitted
  only a string or `null`.
- [`containers.nix`][containers] gives `publish` an attribute set
  `meta = { image = target.image.name; }`, not a string.
- [`newExtractFor.nix`][extract] forwards `action'.meta` unchanged to CI candidates.
- The [Block Type snapshot][blocktypes-snapshot] records
  `meta = { image = "repo:tag"; }`. Its [fixture][blocktypes-test] inspects action
  definitions with synthetic Targets, not full-registry schema validation.

**Original question:** Which shape should `ci.meta` guarantee, and which schema,
producer or consumer changes, if any, should follow?

**Additional discovery evidence:** [C2](scenario-review.md#c2-ci-metadata-schema-and-consumer-expectations)
subsequently evaluated the real producer with a synthetic Target and ran a Draft
2020-12 validator. It rejected exactly `ci.x86_64-linux[0].meta`; null/string
controls conformed but were not accepted as solutions. The original F4 verifier
`failed` before executing its jq filters. A separately authorized data-only
follow-up on 2026-10-27 repaired the copied extractor and completed the verifier
on the retained JSON: the image expression reads the object, rejects the string
(exit 5) and emits `image=null` for null (exit 0). Data transport, grouping and
runner-field rendering were also exercised; the resulting shell strings were
not executed. Provisos and full CI remain unexecuted. The original failed run is
preserved, and neither the schema nor these bounded filter results establish a
live CI failure or decide which side should change.

**Local decision, 2026-10-27:** the requesting user explicitly selected
`object | null` and authorized the schema correction. `meta` remains optional,
objects permit arbitrary properties, and `image` is not required globally. The
[current registry contract](../reference/registry.md#current-ci-metadata-contract)
implements that choice without changing the producer, extractor or proviso.
This decision is separate from discovery approval and from passing tests.

**Compatibility consequence:** strings admitted by the former schema no longer
conform, including strings containing encoded JSON. Custom Block Types using
strings need action-specific migration; no automatic conversion is introduced.
The schema stays at `v0`; this correction does not resolve Q4's evolution policy
or establish backward compatibility. No exhaustive inventory of custom producers
or external consumers, and no end-to-end CI execution, has been completed.

**Remaining validation owner:** unassigned. Framework/schema maintainers and CI
consumers, including the external `divnix/std-action` integration, still need to
assess migration and compatibility impact. The user's local decision does not
represent those external consumers.

## Q2. Cell Block functions and attribute sets

**Knowledge status:** `disputed` public contract; `observed` permissive importer.

- [Conventions](../reference/conventions.md#cell-block-file-arguments) says each
  Block is a function with `{ inputs, cell }` arguments.
- Accepted [ADR 0002][adr-interface] restricts the entry-level calling interface
  for local reasoning; it does not document an attrset exception.
- [`types/default.nix`][types] accepts an attribute set or the prescribed
  function signature. [`grow/default.nix`][grow] returns imported sets directly
  and calls functions with the signature.

**Question:** Is the attrset form a supported public alternative, a scoped
exception, or implementation behavior that should not be relied on? How should
that answer relate to the accepted calling-interface decision?

**Additional discovery evidence:** [A2](scenario-review.md#a2-function-versus-attribute-set-import)
observed equal values, serialized registry and Action derivation paths for one
function/attrset pair using `scopedImport`. This does not establish general
equivalence or accept the attrset form as a public alternative.

**Validation owner:** unassigned. Framework maintainers must validate intent with
Cell authors/consumers. Do not silently weaken the convention to a recommendation
or remove the supported code path as a documentation correction.

## Q3. Preprocessor licensing

**Knowledge status:** `unknown` upstream permission; `observed` recorded status.

The preprocessor's existing [Licensing note][preprocessor] records that its
manifest names a missing `LICENSE` file and that no upstream license was found
for the imported revision. [`.reuse/dep5`][reuse] marks the imported files
`LicenseRef-Unknown`; the [marker text][unknown-license] is not a license grant.
That note also explains why `reuse lint` flags the marker.

**Question:** What license or permission covers the imported upstream files,
and who will obtain and record attributable evidence?

**Validation owner:** unassigned. Repository maintainers need evidence from the
relevant upstream rights holders. Neither the surrounding repository's Unlicense
annotation nor a successful build resolves this question. The existing status
must not be replaced with an inferred license.

## Q4. Registry evolution and compatibility

**Knowledge status:** `unknown` accepted evolution policy; `observed` consumer
coupling.

[`grow`][grow] and the [schema][schema] declare `v0`. The
[consumer paths](../reference/registry.md#consumers-and-translations) read selected
registers using their own shapes: Go and Rust do not negotiate the schema
version, direnv selects an action path, and CI delegates to an external action.
No migration or compatibility commitment is established by those reviewed
sources. This is a knowledge gap, not proof that no agreement exists elsewhere.

**Question:** What compatibility expectations do maintainers accept for registry
fields, names and executable paths, and how should a future change coordinate
in-tree and external consumers? The `cellsFrom` basename/checkout distinction
and Q1 are concrete cases a policy must account for, not silently normalize.

**Additional discovery evidence:** [C3 / P-F4](scenario-review.md#c3-same-derivable-target-different-name)
renamed a Target from `old` to `new`: its derivation and build command stayed the
same, while the old selector disappeared, `enter` changed its profile path and
the `old.md` association was lost. Both registries conformed to schema v0; this
does not answer whether losing `old:enter` is compatible. The data-only jq
follow-up observed the rename in `jobName` and rendered runner fields, without
executing those strings. Go/Rust/direnv and end-to-end CI impacts remain inferred
rather than executed.

**Validation owner:** unassigned. Framework maintainers and maintainers of the
Go, Rust, direnv and CI consumers need to establish the intended scope. Until
then, the registry reference documents observations, not a newly accepted
versioning or backward-compatibility guarantee.

## Scenario-specific questions and operational gap

These discovery identifiers remain **open**, alongside Q2/Q4 and Q1's remaining
compatibility review. Acceptance of F1–F5 did not resolve them, assign owners or
authorize implementation. The
[scenario review](scenario-review.md#open-decisions-and-accountable-perspectives)
records the evidence, impact and necessary perspectives; these are not an
authorized backlog.

| Identifier                                                                                  | Unresolved question                                                                                                         | Needed perspectives (owners unassigned)                                 |
| ------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| [P-F1 / C1](scenario-review.md#c1-different-consumers-different-projections)                | Should `foo-action` be admissible in CI discovery with `ci.foo-action` enabled?                                             | Framework/external CI maintainers and Block author                      |
| [P-F2 / A3](scenario-review.md#a3-two-soil-layers-with-the-same-identity)                   | Must all announcements/candidates of a colliding identity correspond to their own selectable command?                       | Core/Soil maintainers, Cell authors and CLI/CI consumers                |
| [P-F3 / B2](scenario-review.md#b2-required-arguments-in-tui-and-direct-cli)                 | Must `requiresArgs = true` reject missing arguments in direct CLI as well as TUI?                                           | Framework/CLI maintainers and Action authors                            |
| [P-F4 / C3](scenario-review.md#c3-same-derivable-target-different-name)                     | Is renaming under v0 compatible when `old:enter` stops resolving? A concrete instance of Q4, not a separate accepted policy | Framework and consumer maintainers with Cell authors/consumers          |
| [B3 operational gap](scenario-review.md#b3-partial-publication-and-unknown-remote-outcomes) | Who may assess per-tag evidence and authorize recovery after partial/unknown publication?                                   | Authorized publication/destination operator and integration maintainers |

The B3 mock is not a real incident or recovery test. Identify operational
authority before any real retry; no generic retry or rollback rule is inferred.
Q3 remains open and outside the nine-scenario discovery scope.

[baseline]: https://github.com/nadanix/std/tree/322921ba8adda373f1a4bb57b78fc201322c8b93
[schema]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/registry.schema.json
[containers]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/containers.nix
[extract]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/newExtractFor.nix
[blocktypes-snapshot]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/tests/_snapshots/bt-blocktypes
[blocktypes-test]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/tests/bt-blocktypes/expr.nix
[adr-interface]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/docs/explain/architecture-decision-records/0002-restrict-the-calling-interface.md
[types]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/types/default.nix
[grow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/core/grow/default.nix
[preprocessor]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/mdbook-paisano-preprocessor/README.md#licensing
[reuse]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/.reuse/dep5
[unknown-license]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/LICENSES/LicenseRef-Unknown.txt
