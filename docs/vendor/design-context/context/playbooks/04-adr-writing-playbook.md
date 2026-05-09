# ADR Writing Playbook

## Summary

- Write ADRs for structural decisions that should not be rediscovered later.
- Keep them small, explicit, and consequence-oriented.
- Record alternatives and trade-offs, not just conclusions.
- Link ADRs to the maps, manifests, and canonical docs they affect.

## Use this when

- making a meaningful architecture or repository-structure decision
- renaming an important concept with broad impact
- defining a review policy or distribution boundary
- resolving a recurring ambiguity that should stay resolved

## Triggers that justify an ADR

Write an ADR when a decision changes:
- repository structure
- canonical vocabulary or boundaries
- retrieval behavior
- review policy
- distribution or packaging policy
- integration strategy with other agent tools

## Steps

### 1. State the context

Describe the problem, pressure, or ambiguity.

### 2. Record the decision

Write the chosen approach plainly.

### 3. Record rationale and alternatives

Note what options were considered and why the chosen one won.

### 4. Record consequences

Capture both benefits and costs.

### 5. Link impacted artifacts

Update or reference:
- maps
- manifests
- principle docs
- playbooks
- review docs

## Minimum ADR outline

```text
# ADR 000X: <Decision>
- Status: Accepted
- Date: YYYY-MM-DD

## Context
## Decision
## Rationale
## Consequences
```

## Good ADR qualities

- easy to scan
- specific about what changed
- explicit about consequences
- linked to affected artifacts
- not used for temporary status updates

## Review questions

- Will future contributors need this decision explained again?
- Does this change affect multiple artifacts or future direction?
- Are alternatives and consequences explicit?
- Have the impacted maps/manifests been updated?

## Related docs

- `docs/adr/0001-information-architecture-and-manifests.md`
- `docs/adr/0002-lightweight-validation-before-agent-exports.md`
- `docs/adr/0005-core-context-pack-and-vendoring-boundary.md`
- `context/review/01-quality-gates.md`
