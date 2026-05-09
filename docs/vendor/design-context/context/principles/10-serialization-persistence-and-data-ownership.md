# Serialization, Persistence, and Data Ownership

## Summary

- Persistence and serialization are translation concerns, not the source of domain truth.
- Push persistence to the edges and keep the core model persistence-aware only where the domain truly requires it.
- Distinguish domain representations from DTOs, records, documents, or wire shapes.
- Let bounded contexts own their data and contracts explicitly.
- Separate write-side consistency concerns from read-side convenience where useful.

## Load this when

- integrating persistence into a domain model
- defining DTO or storage mappings
- deciding who owns data across bounded contexts
- reviewing whether the database has started to own the model

## Principle

DMMF's persistence chapters emphasize that a well-formed model is often mismatched with storage or transport shapes. That mismatch is normal. The design goal is not to eliminate translation but to keep translation from distorting the model.

## Rules

### 1. Treat serialization as a mapping boundary

Domain types and transport/storage shapes may differ. Translate deliberately rather than pretending they are the same object.

### 2. Push persistence to the edges

Persistence should adapt to the domain model where possible, not rewrite the domain model into storage-first shapes.

### 3. Let bounded contexts own their data

A bounded context should control the meaning and lifecycle of its own persisted information. Shared databases do not create shared meaning automatically.

### 4. Distinguish write concerns from read concerns when useful

When read convenience pressures start to distort invariant-protecting write models, consider explicit read-side views or projections.

### 5. Keep transactions aligned with consistency boundaries

Use transactions or equivalent guarantees where invariants must hold together. Do not enlarge consistency boundaries casually just because the database makes it easy.

### 6. Keep mapping logic visible

A reader should be able to find where domain data becomes DTOs, persistence records, or wire formats.

## Warning signs

Refactor when you see:
- domain names collapsing into table-driven or endpoint-driven names
- persistence fields becoming the real specification
- multiple contexts editing the same data without explicit ownership
- mapping logic scattered through handlers and adapters

## Review questions

- Where does the domain representation become a storage or wire representation?
- Is persistence shaping the model more than the domain is?
- Which bounded context owns this data and its meaning?
- Are read conveniences distorting write-side invariants?

## Related docs

- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/patterns/03-error-and-edge-translation-patterns.md`
- `context/playbooks/07-persistence-and-mapping-boundaries-playbook.md`
