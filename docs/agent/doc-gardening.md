# Doc Gardening

## Summary

- Documentation is part of the agent harness, not an afterthought.
- Stale docs act like attractive nuisances: agents may trust them and spread bad
  patterns.
- Prefer continuous small cleanups over rare large documentation rewrites.
- When a repeated cleanup is mechanical, make it executable.

## What to garden

| Artifact             | Drift signal                         | Cleanup action                                         |
| -------------------- | ------------------------------------ | ------------------------------------------------------ |
| `AGENTS.md`          | Grows into a handbook.               | Move detail into `docs/` and keep links.               |
| Maps                 | New docs are hard to discover.       | Add/update nearest `00-map.md`.                        |
| Manifests            | Paths missing or stale.              | Update `docs/manifests/*.yaml`.                        |
| Architecture docs    | Terms diverge from code or glossary. | Update canonical doc and link dependents.              |
| Dependency contracts | Flake inputs change without docs.    | Update `dependency-contracts.md`.                      |
| Generated snapshots  | Source inventory changed.            | Regenerate or update `docs/generated/*`.               |
| Plans                | Completed work remains active.       | Move to `completed/` or promote lessons to invariants. |

## Garbage collection workflow

1. Run `tooling/check-agent-knowledge.sh`.
2. Inspect recent source changes for docs that should have changed with them.
3. Remove or rewrite stale guidance instead of adding contradictory notes.
4. Promote recurring review comments into `invariants.md` or tooling.
5. Keep cleanup PRs narrow unless a broader re-map is explicitly requested.

## Golden principles

- Repository-local knowledge is the system of record for agents.
- A map beats a long manual.
- Important taste should be encoded once and enforced continuously.
- Generated docs should identify their source of truth.
- If an agent cannot find it from `AGENTS.md` or `docs/00-map.md`, it effectively
  does not exist.

## Review questions

- Is this doc still true according to current source behavior?
- Does this guidance belong here, or in a smaller leaf doc?
- Can a script detect the drift next time?
- Is this cleanup reducing future context cost?

## Related docs

- `validation-harness.md`
- `docs/architecture/invariants.md`
- `docs/architecture/quality-score.md`
