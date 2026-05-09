# Architecture Review Checklist

## Summary

- Use this checklist to review domain shape, boundaries, workflows, errors, contracts, and retrieval structure.
- Apply it to canonical docs or project-specific context packs.
- Mark findings by severity so reviewers know what must change first.

## Use this when

- reviewing a new context pack
- auditing a bounded context definition
- evaluating whether a design is ready to become canonical guidance

## Severity guide

- **Critical**: breaks meaning, boundaries, or canonical retrieval
- **Major**: creates substantial ambiguity or maintenance cost
- **Minor**: weakens clarity or consistency but does not break the model

## Checklist

### Boundaries and ownership

- [ ] the bounded context has a clear purpose
- [ ] responsibilities and non-responsibilities are explicit
- [ ] strategic importance is recorded when it changes modeling depth
- [ ] neighboring contexts or systems are identified
- [ ] translations are explicit where meanings differ
- [ ] important cross-context contracts are named and easy to find

### Vocabulary and meaning

- [ ] canonical terms are stable and glossary-aligned
- [ ] the same word is not carrying conflicting meanings in one scope
- [ ] units, ranges, precision, and measurement meaning are explicit where relevant
- [ ] domain language dominates technical placeholder language

### Workflows and state

- [ ] important workflows are named by business intent
- [ ] states and transitions are explicit where behavior changes over time
- [ ] invariants are visible near the workflows or states they govern
- [ ] long-running concerns are documented when relevant
- [ ] important business events are explicit where workflows hand off or publish outcomes

### Errors and edges

- [ ] domain-significant failures are named in domain language
- [ ] input/contract failures are distinct from operational failures
- [ ] transport, storage, and vendor concerns stay at the edge
- [ ] edge effects are separated from core decisions

### Structure and retrieval

- [ ] the area has a clear map and manifest path
- [ ] the canonical docs are easy to find in under two hops
- [ ] split/join decisions reduce reader burden instead of only changing file count
- [ ] no file is trying to be map, principle, playbook, and review checklist at once
- [ ] downstream guidance does not redefine canonical principles

## Reporting pattern

For each issue, record:
- severity
- artifact path
- observed problem
- recommended fix

## Related docs

- `context/review/01-quality-gates.md`
- `context/review/03-documentation-quality-checklist.md`
- `context/principles/00-map.md`
