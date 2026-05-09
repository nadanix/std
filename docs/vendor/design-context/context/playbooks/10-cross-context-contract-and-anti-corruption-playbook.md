# Cross-Context Contract and Anti-Corruption Playbook

## Summary

- Treat context-to-context communication as part of the model, not as plumbing.
- Record who owns the contract, which terms are shared, which are translated, and what failure surface is stable.
- Use anti-corruption layers when a foreign model should not leak inward.
- Keep contract notes compact, but explicit enough that readers can review ownership and change impact.

## Use this when

- defining how two bounded contexts interact
- integrating with a vendor or legacy system
- reviewing whether a seam is leaking foreign concepts
- documenting a stable event or request/response contract

## Inputs

- bounded-context definitions
- workflow or event catalog
- glossary terms for both sides of the seam
- persistence or ownership notes if data moves across the boundary

## Steps

### 1. Identify the interaction and its purpose

State:
- who is talking to whom
- in which direction the interaction flows
- what business purpose the interaction serves

Examples:
- request payment authorization
- publish a shipment outcome
- consume a shipping confirmation

### 2. Choose the relationship model

Ask which seam shape best fits:
- shared vocabulary by agreement
- supplier-owned contract that the consumer conforms to
- consumer-driven contract
- anti-corruption layer translating a foreign model

Do not flatten these into one generic “integration” label.

### 3. Record the stable contract surface

Document:
- message or request name
- required meaning and fields
- success outcomes
- failure envelope
- versioning or compatibility notes if relevant

### 4. Separate shared terms from translated terms

Create a small table showing:
- terms that truly mean the same thing on both sides
- terms that need translation
- terms that stay private to one side

### 5. Place the anti-corruption boundary deliberately

If the foreign side uses a mismatched model, decide where translation happens.
That boundary should:
- accept the foreign shape
- classify or translate it
- emit a smaller inward-facing concept set

The point is semantic protection, not just validation.

### 6. Record ownership expectations

Note which side owns:
- the business meaning of the interaction
- durable state changes
- identifiers introduced by the seam
- backward-compatibility expectations

### 7. Include failure and recovery expectations

A useful contract should answer:
- what failures are domain-significant here?
- what failures are merely operational?
- who retries or compensates?
- what should the receiver rely on when the interaction is incomplete or delayed?

### 8. Link the contract back to workflows and data ownership

A contract artifact should point to:
- the emitting or calling workflow
- the consuming workflow
- the bounded contexts involved
- the persistence or read-model note if data is projected elsewhere

## Output shape

Use a compact contract note with:
- summary table
- shared/translated terms
- stable outcomes and failures
- anti-corruption notes
- change and compatibility notes

## Review questions

- Who owns the contract shape, and is that obvious?
- Which terms are truly shared versus merely similar?
- Where does translation happen, and what stays private behind it?
- Does the contract expose only what the receiver needs?
- Would a vendor or storage change force unnecessary changes in the core model?

## Related docs

- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/principles/10-serialization-persistence-and-data-ownership.md`
- `context/patterns/01-boundary-and-decomposition-patterns.md`
- `context/patterns/03-error-and-edge-translation-patterns.md`
- `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
- `context/review/05-event-and-contract-artifact-checklist.md`
