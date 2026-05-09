# Architecture and Taste Invariants

## Summary

- These are the rules that should remain stable as agent throughput increases.
- Prefer enforcing invariants over micromanaging implementation choices.
- When a doc rule becomes important enough to prevent drift, promote it into a
  script, test, linter, or generated check.

## Core architecture invariants

| Invariant                                                                 | Why it matters                                                       | Current enforcement                             |
| ------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------- |
| Cell Blocks expose only `{ inputs, cell }`.                               | Preserves local reasoning and consistent repo shape.                 | Convention, docs, examples.                     |
| `Cell -> Cell Block -> Target -> Action` remains the public mental model. | Keeps std repos legible to humans, agents, CLI/TUI, and CI.          | Docs, registry, examples.                       |
| Block Types own reusable action definitions.                              | Avoids target-specific action sprawl.                                | Source layout and catalog check.                |
| Optional integrations use input overloading.                              | Keeps core lightweight while allowing vertical tooling.              | `blank`, `requireInput`, docs.                  |
| Action scripts go through `mkCommand`.                                    | Provides shell strictness, PRJ env checks, and dependency injection. | Source review.                                  |
| Runtime dependencies are declared by actions.                             | Prevents hidden ambient tool assumptions.                            | Source review, shellcheck at build.             |
| `AGENTS.md` is a map, not a handbook.                                     | Protects agent context budget.                                       | `tooling/check-agent-knowledge.sh` line budget. |
| Durable repo knowledge lives under `docs/` or executable checks.          | Makes knowledge visible to agents and new contributors.              | Maps, manifests, docs.                          |

## Boundary invariants

- Paisano-owned concepts should not be silently redefined by `std` docs.
- Vertical tool details should not become core std vocabulary.
- Dogfood-only concerns should not leak into downstream framework contracts.
- Generated or generator-owned docs should identify their source of truth.
- New direct inputs should be documented in `dependency-contracts.md`.

## Agent-legibility invariants

- A new agent should find the relevant architecture doc in under two hops from
  `AGENTS.md` or `docs/00-map.md`.
- Every major architecture area should have a map or manifest entry.
- Important rules should be stated once and linked, not repeated with drift.
- Feedback from review or recurring defects should become docs or checks.
- Stale docs should be garbage-collected continuously in small changes.

## Review questions

- Is this rule central enough to enforce mechanically?
- Can an agent detect violations without hidden human knowledge?
- Is the invariant stated at the right abstraction level?
- Does enforcement preserve local autonomy while protecting global boundaries?

## Related docs

- `docs/agent/validation-harness.md`
- `docs/agent/doc-gardening.md`
- `dependency-contracts.md`
- `block-type-catalog.md`
