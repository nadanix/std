# Type-Shaped Models and Illegal States

## Summary

- Treat types, schemas, constructors, and validators as modeling tools, not just implementation detail.
- Prefer trusted representations inside the core and broader, untrusted representations at the edges.
- Make illegal states hard to represent, construct, or persist accidentally.
- Use narrow, named concepts instead of vague primitive fields when the domain cares about the distinction.
- Model quantities, units, currencies, ranges, and precision explicitly when they affect meaning.
- If the language cannot encode the model directly, compensate with explicit construction and validation boundaries.

## Load this when

- shaping a model from domain language
- deciding whether a concept deserves a dedicated type or wrapper
- designing validation boundaries
- trying to reduce defensive checks scattered through the core

## Principle

One of the deepest lessons from DMMF is that the model becomes safer and clearer when domain distinctions are reflected in the representations we allow to exist.

In some languages this is done with rich static types. In others it may be done with constructors, opaque wrappers, schema validation, parsing stages, and trusted/untrusted data transitions. The language changes; the design move does not.

## Rules

### 1. Prefer named domain shapes over generic primitives

If the domain distinguishes them, the model should distinguish them.

Prefer:
- `EmailAddress`
- `RenewalWindow`
- `ValidatedOrder`

Over raw strings, booleans, or loosely grouped maps when those erase meaning.

### 2. Model quantities, units, and measures explicitly

A number is often not enough.

When the domain cares about units, currency, scale, precision, valid range, or measurement origin, encode that meaning in a named representation or validation boundary.

Prefer a trusted `MoneyAmount`, `Distance`, or `Percentage`-style concept over a raw number when mixing values would create invalid behavior.

### 3. Separate untrusted input from trusted core data

Model the transition from outside data to trusted domain data explicitly.

Common stages:
- raw or unvalidated input
- parsed or classified input
- trusted domain representation

### 4. Make illegal states hard to construct

The goal is not perfection through a specific type system. The goal is to reduce the number of places where invalid combinations can arise.

Use:
- dedicated constructors
- validation gates
- narrowed internal representations
- explicit state variants
- aggregate boundaries that protect invariants

### 5. Keep validation close to construction

If a value has rules, prefer enforcing them when the value first becomes trusted, not repeatedly throughout the workflow.

### 6. Model optionality, alternatives, and collections explicitly

Do not hide meaningful absence, multiplicity, or alternatives inside vague conventions.

Make the model say whether something is:
- optional
- required
- one of several variants
- many values with constraints

### 7. Use representations that help domain review

A good domain representation should make the important distinctions visible to a reviewer, not just to the runtime.

## Warning signs

Refactor when you see:
- many primitive fields carrying hidden rules
- raw numeric fields without explicit units, ranges, or precision where the domain cares
- repeated validation of the same concept in many places
- unclear transitions between raw input and trusted domain data
- vague names such as `data`, `payload`, or `info` holding semantically different things

## Review questions

- Does the model distinguish the concepts the domain distinguishes?
- Are units, currency, ranges, and precision explicit where they affect behavior?
- Where does raw input become trusted domain data?
- Are invalid combinations prevented early or merely caught later?
- Would a reviewer understand the intended distinctions from the model surface?

## Related docs

- `context/principles/02-ubiquitous-language-and-naming.md`
- `context/principles/04-workflows-invariants-and-state.md`
- `context/principles/08-entities-value-objects-and-aggregates.md`
- `context/playbooks/05-trusted-and-untrusted-representations-playbook.md`
