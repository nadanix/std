# Errors and Edge Responsibilities

## Summary

- Prefer designs that prevent invalid states over designs that merely catch them later.
- Make failure modes explicit in the model and at boundaries.
- Keep transport, persistence, serialization, and vendor details at the edges.
- Translate edge failures before they enter the core model.
- Document which errors are domain-significant and which are operational noise.

## Load this when

- defining validation and failure behavior
- deciding where persistence or integration logic belongs
- reviewing boundary purity
- deciding how to document edge concerns without polluting the core model

## Principle

Not all failures are the same. Some are domain-significant and belong in the model. Others are operational accidents of the environment. Good design distinguishes them clearly and prevents the latter from distorting the former.

## Error rules

### 1. Prefer prevention over rescue

Use the model, glossary, schemas, state tables, and checklists to make invalid interpretations harder.

Do not rely on a late generic catch-all as the primary design mechanism.

### 2. Classify errors by meaning

At minimum, distinguish:
- domain errors: the business rule says no
- boundary or contract errors: the input or interaction shape is wrong
- operational errors: storage, network, timeout, auth, dependency failure

This separation helps keep workflows understandable.

### 3. Keep domain errors close to the domain

If a failure changes business meaning, the model should name it directly.

Examples:
- order already cancelled
- claim window expired
- credit limit exceeded

These should not be hidden under vague technical labels.

### 4. Keep operational details at the edge

The core model should not need to know about:
- HTTP status codes
- Kafka partitions
- SQL driver exceptions
- vendor SDK exception types

Translate these into stable boundary results or operational categories before they move inward.

### 5. Document edge responsibilities explicitly

At the edges, be clear about who handles:
- validation of external shape
- serialization or deserialization
- persistence mapping
- retries and timeouts
- authentication or authorization seams
- logging, tracing, or metrics emission

### 6. Keep side-effect adapters replaceable

If an external dependency changes, the core model and its main principles should remain mostly intact.

### 7. Make unknown or unhandled failures visible

If a failure cannot be classified yet, mark it as unresolved rather than hiding it under a misleading category.

## Core vs edge guideline

| Concern | Preferred location |
|---|---|
| business rules | core model |
| state transitions | core model |
| invariant definitions | core model |
| input shape adaptation | edge |
| transport protocol details | edge |
| persistence mapping | edge |
| retries/timeouts/circuit breaking | edge |
| vendor-specific behavior | edge |

## Minimum error documentation

A meaningful workflow or boundary description should usually answer:

- what failures are business-significant?
- what failures are input or contract problems?
- what failures are operational?
- where are they detected?
- where are they translated?
- what can the caller or downstream context rely on?

## Review questions

- Does the core model depend on transport or storage details?
- Are business-significant failures named in domain language?
- Are operational failures translated before entering the core?
- Have we prevented obvious invalid states rather than only catching them?
- Would a dependency change force unnecessary model changes?

## Related docs

- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/principles/04-workflows-invariants-and-state.md`
- `context/principles/06-deep-modules-and-information-hiding.md`
