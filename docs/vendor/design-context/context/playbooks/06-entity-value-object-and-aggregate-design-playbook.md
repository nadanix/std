# Entity, Value Object, and Aggregate Design Playbook

## Summary

- Use identity only where the domain truly cares about continuity over time.
- Use value objects where meaning and validity matter more than identity.
- Choose aggregates based on invariant ownership, not file structure or ORM habits.
- Make cross-aggregate coordination explicit.

## Use this when

- classifying key concepts in a model
- deciding whether something needs its own identity
- defining aggregate boundaries and responsibilities

## Inputs

- glossary terms
- workflow descriptions
- invariant list
- consistency requirements

## Steps

### 1. List the important concepts

Start from the glossary and workflows, not from implementation classes.

### 2. Ask whether continuity matters

For each concept, ask:
- do we care that this is the same thing over time?
- does it have its own lifecycle?
- do others refer to it as a stable identity?

If yes, it may be an entity.
If no, it may be a value object.

### 3. Identify the value objects

Look for concepts mostly defined by:
- attributes
- validation rules
- semantic meaning
- replacement rather than tracked continuity

### 4. Identify aggregate boundaries

Ask:
- which invariants must hold together?
- what must be consistent at update time?
- where would splitting create unsafe partial updates?

### 5. Define cross-aggregate coordination explicitly

If multiple aggregates must interact, note the workflow, event, or orchestration step that coordinates them.

### 6. Record the design decision

Create a short classification note or table.

## Output shape

| Concept | Entity or VO | Why | Aggregate |
|---|---|---|---|
| order | entity | continuity and lifecycle matter | Order aggregate |
| shipping address | value object | semantic rule set without independent identity | Order aggregate |
| payment authorization | entity | authorization identity and status history matter | Payment aggregate |

## Review questions

- Did we add identity only where the domain needs it?
- Which invariants define the aggregate boundary?
- Are cross-aggregate interactions explicit?
- Did we avoid a one-aggregate-per-context default?

## Related docs

- `context/principles/08-entities-value-objects-and-aggregates.md`
- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/playbooks/02-bounded-context-definition-playbook.md`
