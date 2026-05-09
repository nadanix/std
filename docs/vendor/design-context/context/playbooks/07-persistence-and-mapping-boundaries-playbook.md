# Persistence and Mapping Boundaries Playbook

## Summary

- Keep domain representations distinct from storage and wire representations.
- Make mapping logic visible and local to the boundary where it belongs.
- Let bounded contexts own their data and persistence rules explicitly.
- Keep transactions aligned with invariant ownership, not convenience alone.

## Use this when

- adding persistence to a domain model
- defining DTO or storage mappings
- reviewing whether a database shape is distorting the model

## Inputs

- aggregate or context definitions
- workflow descriptions
- storage or transport constraints
- read and write use cases

## Steps

### 1. Identify owned data by bounded context

For each context, answer:
- what data meaning is owned here?
- what should not be edited directly by neighboring contexts?

### 2. Separate domain shapes from persistence shapes

List:
- domain entities / value objects / aggregates
- storage records or documents
- DTOs or wire payloads

### 3. Define mapping points

Show where translation happens:
- inbound mapping from storage/wire shape to domain shape
- outbound mapping from domain shape to storage/wire shape

### 4. Align transactions with invariants

Ask:
- which updates must stay consistent together?
- which operations may be eventual or asynchronous?

### 5. Decide whether read models should diverge

If read convenience is distorting the write model, note the need for projections, views, or separate read shapes.

### 6. Record ownership and contract notes

Create a small table or note showing data ownership, mapping boundaries, and storage independence expectations.

## Output shape

| Context | Owned data meaning | Mapping boundaries | Notes |
|---|---|---|---|
| Ordering | order state and fulfillment meaning | API payload ↔ order command; aggregate ↔ order record | no direct payment-owned updates |
| Payment | authorizations and provider outcomes | provider payload ↔ payment outcome; authorization ↔ payment record | provider detail stays local |

## Review questions

- Is persistence adapting to the model or reshaping it?
- Are mapping points easy to find?
- Which bounded context owns this data's meaning?
- Are read-side conveniences distorting write-side invariants?

## Related docs

- `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
- `context/principles/10-serialization-persistence-and-data-ownership.md`
- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
