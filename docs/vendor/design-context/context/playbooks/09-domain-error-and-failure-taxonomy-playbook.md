# Domain Error and Failure Taxonomy Playbook

## Summary

- Start from workflow meaning and invariants, not from exception classes or transport codes.
- Distinguish domain rejections, contract failures, operational failures, and unexpected outcomes.
- Translate detailed edge failures into smaller stable failure envelopes before they move inward.
- Record where each failure is detected, who owns it, and who is expected to recover.

## Use this when

- defining a workflow failure model
- reviewing whether edge concerns are leaking into the core
- creating a stable error surface for callers or neighboring contexts
- clarifying retry, escalation, or compensation responsibilities

## Inputs

- workflow description
- invariants and forbidden situations
- trust-boundary notes
- external dependencies and contracts

## Steps

### 1. Start from the workflow goal

Ask:
- what business result is this workflow trying to produce?
- what explicit rejections are part of normal business behavior?
- what must stay true before and after the workflow?

### 2. List failure points by stage

Walk the workflow from input to output.
For each stage, note what can go wrong at:
- intake or parsing
- validation and trust earning
- domain decision points
- cross-context or external calls
- persistence or message emission

### 3. Classify failures by meaning

Use at least these categories:

| Category | Meaning | Example |
|---|---|---|
| domain rejection | the business rule says no | claim window closed |
| contract failure | the shape or boundary interaction is wrong | malformed request payload |
| operational failure | infrastructure or dependency issue | provider timeout |
| unexpected outcome | valid signal at the wrong time or state | payment success with no pending order |

### 4. Decide what crosses the boundary

Not every failure deserves the same visibility.
Ask:
- should this stay local to the edge adapter?
- should this become a stable inward category?
- does the caller need the exact detail, or only a translated envelope?

### 5. Collapse detailed edge errors into stable categories

Examples:
- provider error codes → `payment outcome unavailable`
- storage driver exceptions → `state persistence failed`
- transport parse errors → `invalid request`

Keep the detailed originals for diagnostics, but do not let them become the core language by accident.

### 6. Record owner and recovery responsibility

For each failure, note:
- where it is detected
- who names or classifies it
- who decides retry, escalation, compensation, or rejection

### 7. Build the taxonomy table

Recommended shape:

| Failure | Category | Detected at | Stable surface | Recovery owner | Notes |
|---|---|---|---|---|---|
| order already submitted | domain rejection | Ordering workflow | duplicate order rejected | Ordering | prevents duplicate submission |

### 8. Link the taxonomy to trust boundaries and contracts

A strong taxonomy should connect back to:
- the trust boundary where raw input becomes trusted
- the contract where neighboring contexts rely on a stable failure surface
- the workflow that decides whether retry or compensation is allowed

## Output checklist

- [ ] domain failures are named in domain language
- [ ] contract failures are distinct from operational failures
- [ ] unexpected outcomes are not silently forced into normal paths
- [ ] detailed edge failures are translated before entering the core
- [ ] recovery ownership is explicit for important failures

## Review questions

- Which failures are genuine business outcomes versus environmental accidents?
- Would a vendor or transport change force the taxonomy to change?
- Are retry decisions expressed in domain terms and executed at the edge?
- Are there any vague categories such as `unknown error` hiding modeling work?
- Can a neighboring context rely on a stable failure envelope from this artifact?

## Related docs

- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/principles/07-type-shaped-models-and-illegal-states.md`
- `context/playbooks/05-trusted-and-untrusted-representations-playbook.md`
- `context/patterns/03-error-and-edge-translation-patterns.md`
- `context/review/05-event-and-contract-artifact-checklist.md`
- `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
