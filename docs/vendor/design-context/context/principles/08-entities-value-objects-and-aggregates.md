# Entities, Value Objects, and Aggregates

## Summary

- Identity is a modeling decision, not a default implementation habit.
- Value objects are defined by meaning and validity, not by an ID.
- Entities represent continuity over time and across state changes.
- Aggregates define the boundary inside which certain invariants must remain consistent together.
- Cross-aggregate coordination should be explicit instead of silently shared.

## Load this when

- deciding whether something is a value object or entity
- defining aggregate boundaries
- reviewing invariant ownership
- reducing accidental over-modeling or under-modeling

## Principle

DMMF treats the value object / entity / aggregate distinction as a way to preserve semantic clarity. The question is not "what class should this be?" but rather:
- does this thing have identity of its own?
- do we care about its continuity over time?
- which invariants must hold together?

## Rules

### 1. Use value objects for concepts defined by their attributes and validity

A value object is usually the better fit when:
- identity does not matter independently
- the concept is mostly about meaning and constraints
- replacement is simpler than mutation

Examples:
- email address
- money amount
- settlement window
- validated postal code

### 2. Use entities when continuity matters

An entity is usually the better fit when the domain cares that it is the same thing across time, state changes, or references.

### 3. Do not add IDs just because tooling prefers them

If identity is not domain-significant, adding an ID can blur the model rather than clarify it.

### 4. Use aggregates to protect consistency boundaries

An aggregate is the boundary inside which certain invariants must be maintained together.

Choose aggregate boundaries based on:
- invariant ownership
- transactional consistency needs
- update patterns
- semantic cohesion

### 5. Keep aggregates smaller than the whole context

A bounded context is not the same as a single aggregate. Many contexts need multiple aggregates coordinated through explicit workflows or outcomes.

### 6. Coordinate across aggregates explicitly

When multiple aggregates must interact, prefer:
- explicit workflows
- domain outcomes or events
- application-layer orchestration

Do not silently rely on shared mutable internals.

## Warning signs

Refactor when you see:
- IDs added to every concept by default
- aggregates so large that unrelated changes collide constantly
- invariants that no clearly owned boundary protects
- value objects mutated as if identity mattered

## Review questions

- Is identity actually significant here?
- Which invariants belong together, and where are they protected?
- Is the aggregate boundary earning its coordination cost?
- Are cross-aggregate interactions explicit enough to review?

## Related docs

- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/principles/07-type-shaped-models-and-illegal-states.md`
- `context/playbooks/02-bounded-context-definition-playbook.md`
- `context/playbooks/06-entity-value-object-and-aggregate-design-playbook.md`
