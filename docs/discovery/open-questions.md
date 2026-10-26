# Open questions

These are unresolved questions about the current implementation and its
contracts, not decisions or instructions to change behavior. Evidence was
rechecked against [`322921b`][baseline]. The
[repository map](../explain/repository-map.md) provides orientation and the
[registry reference](../reference/registry.md) describes the observed boundary.

Knowledge status is separate from resolution status: `observed` means a cited
artifact contains the evidence; `disputed` means relevant sources disagree;
`inferred` is a conclusion still needing validation; `unknown` marks missing
knowledge. `confirmed` is reserved for acceptance by an accountable validator
within a stated scope, not for agreement between code and a snapshot.

All questions below are **open**. Validation owners have not been assigned;
roles listed below identify perspectives needed, not people who have accepted
responsibility. Maintainer, downstream-consumer and upstream licensing
perspectives are not replaced by this source review.

## Q1. CI metadata shape

**Knowledge status:** `disputed` contract; `observed` static discrepancy.

- [`registry.schema.json`][schema], `definitions.ci` → candidate `meta`, permits
  only a string or `null`.
- [`containers.nix`][containers] gives `publish` an attribute set
  `meta = { image = target.image.name; }`, not a string.
- [`newExtractFor.nix`][extract] forwards `action'.meta` unchanged to CI candidates.
- The [Block Type snapshot][blocktypes-snapshot] records
  `meta = { image = "repo:tag"; }`. Its [fixture][blocktypes-test] inspects action
  definitions with synthetic Targets, not full-registry schema validation.

**Question:** Which shape should `ci.meta` guarantee, and which schema, producer
or consumer changes, if any, should follow? No JSON Schema validator was run to
establish this observation; the static mismatch is not evidence of a live CI
failure.

**Validation owner:** unassigned. Framework/schema maintainers and CI consumers,
including the external `divnix/std-action` integration, need to agree on the
meaning and compatibility impact. A snapshot match cannot make that decision.

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

**Validation owner:** unassigned. Framework maintainers and maintainers of the
Go, Rust, direnv and CI consumers need to establish the intended scope. Until
then, the registry reference documents observations, not a newly accepted
versioning or backward-compatibility guarantee.

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
