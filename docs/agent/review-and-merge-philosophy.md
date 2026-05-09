# Review and Merge Philosophy

## Summary

- Agent-assisted work increases throughput; the repo must preserve coherence
  through structure, checks, and small feedback loops.
- Prefer enforcing boundaries and invariants over prescribing every local
  implementation choice.
- Corrections should be cheap, targeted, and captured back into the harness.

## Review stance

For routine changes, review should focus on:

- whether the right bounded context owns the change
- whether invariants remain intact
- whether validation is proportionate to risk
- whether docs or generated snapshots drifted
- whether a recurring issue should become a mechanical check

For high-risk changes, add human review when:

- a public API or Block Type contract changes
- an invariant is relaxed
- optional inputs become required
- deploy-like actions or external side effects change
- snapshot changes are large or hard to explain

## Merge posture

`std` is not a fully autonomous agent-generated product, but the harness
engineering lesson still applies: avoid spending human attention where a local
feedback loop can give a reliable answer.

Preferred posture:

1. Keep PRs small enough to review quickly.
2. Run targeted validation before heavy validation.
3. Use follow-up cleanup PRs for low-risk doc or style drift.
4. Promote repeated feedback into docs or checks.
5. Do not block on a giant manual review when a mechanical invariant can be
   encoded instead.

## What agent-generated means here

Agents may produce docs, code, tests, scripts, and review notes. Humans still
own prioritization and judgment. The durable output should be repo-local:

- docs for intent and rationale
- manifests for retrieval
- scripts/tests for enforcement
- generated snapshots for inspection

## Review questions

- Did the change improve or degrade agent legibility?
- Is human taste captured as a reusable invariant or just a one-off comment?
- Could a future agent validate this without asking a human?
- Is the merge risk controlled by checks, by scope, or by explicit review?

## Related docs

- `validation-harness.md`
- `doc-gardening.md`
- `docs/architecture/invariants.md`
