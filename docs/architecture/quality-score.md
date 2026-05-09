# Architecture Knowledge Quality Score

## Summary

This is a lightweight quality snapshot for the new agent-facing architecture
knowledge base. It should be updated when the quality posture changes.

| Area                 | Grade | Notes                                                   | Next improvement                                               |
| -------------------- | ----- | ------------------------------------------------------- | -------------------------------------------------------------- |
| Domain model         | B+    | Core vocabulary and aggregate shape are documented.     | Add examples from downstream repos.                            |
| Bounded contexts     | B+    | Major ownership boundaries are explicit.                | Add ADRs for any contested boundary changes.                   |
| Dependency contracts | B     | Direct inputs and optional integrations are documented. | Generate contract drift checks from flake metadata.            |
| Workflows            | B     | Main framework workflows are explicit.                  | Add state tables for complex deploy/action flows if they grow. |
| Action runtime       | B     | Runtime boundary and failure classes are documented.    | Add source checks for action dependency declarations.          |
| Block Type catalog   | B     | Catalog covers current source files.                    | Generate catalog fully from source and docs metadata.          |
| Agent validation     | B     | Lightweight harness script exists.                      | Wire stable checks into CI or std targets.                     |
| Doc freshness        | C+    | Doc-gardening policy exists.                            | Add recurring or CI-enforced stale-doc checks.                 |

## Quality gates

A change that affects architecture knowledge should answer:

- Which doc or manifest is the system of record?
- Which invariant is being preserved, added, or relaxed?
- Which validation command proves the change did not drift?
- Which generated snapshot, if any, needs to be updated?

## Related docs

- `docs/agent/validation-harness.md`
- `docs/agent/doc-gardening.md`
- `invariants.md`
