# Bounded Contexts and Boundaries

## Summary

- Boundaries partition language, decisions, and model meaning, not just source folders.
- Each bounded context should own its vocabulary, rules, and change cadence.
- Interactions between contexts require explicit translation, not silent leakage.
- A context should expose a small stable surface and hide internal detail.
- Split or merge contexts based on semantic, change, and strategic pressure, not fashion.
- Modeling depth should match the context's business importance.

## Load this when

- decomposing a domain
- deciding whether two concepts belong together
- defining relationships between capabilities or teams
- reviewing context leakage

## Principle

A bounded context is the scope within which a particular model and vocabulary are valid. It is a semantic boundary before it is a technical one.

The purpose of bounded contexts is to keep complexity local, protect meaning, and make change cheaper.

## What a bounded context should define

A bounded context should make the following explicit:

- purpose
- strategic role or investment level when relevant
- primary vocabulary
- owned decisions and rules
- key workflows
- important states and invariants
- inputs and outputs across the boundary
- translations required when talking to other contexts

## Boundary rules

### 1. Keep vocabulary local unless translated

The same word can mean different things in different contexts. That is acceptable if each context is explicit.

Do not assume a term can cross a boundary unchanged.

### 2. Keep internal structure private

Other contexts should not depend on internal entities, internal state shapes, or internal workflow steps unless those are part of an intentional contract.

### 3. Define contracts at the seam

When one context interacts with another, define:
- what is sent or requested
- what is returned or emitted
- which terms are shared
- which terms must be translated
- what failures are expected at the boundary

### 4. Prefer autonomy over accidental coupling

A bounded context is healthier when it can evolve its internals without forcing unrelated changes elsewhere.

### 5. Let change patterns inform boundaries

If two areas always change together for the same business reason, they may belong in one context.
If they evolve for different reasons, at different speeds, or with different vocabularies, consider separating them.

### 6. Match modeling depth to strategic importance

Not every context needs the same modeling investment.

Record whether the area is a core differentiator, a supporting capability, or a generic capability when that distinction changes design effort, review depth, or buy/build decisions.

Use this classification to focus attention, not to weaken semantic boundaries.

## Heuristics for splitting contexts

Consider splitting when:
- the same term is overloaded with conflicting meanings
- one model is forcing awkward compromises on another
- the rate of change differs significantly
- different experts naturally describe the work differently
- integration seams keep appearing informally inside the same area

## Heuristics for merging contexts

Consider merging when:
- two contexts share almost all vocabulary and rules
- the seam adds ceremony without protecting meaning
- every change crosses the boundary anyway
- translations are mostly fake renamings

## Minimal context pack

A reusable context pack for a bounded context should eventually include:

1. a short overview
2. glossary terms
3. responsibilities and non-responsibilities
4. workflows
5. invariants and states
6. contracts with other contexts
7. review questions

## Context relationships

When documenting multiple contexts, capture the relationship explicitly. Examples:
- upstream/downstream
- shared vocabulary by agreement
- translated interaction
- anti-corruption or shielding layer

The exact notation may vary, but the semantic relationship must be clear.

## Review questions

- Does this boundary protect meaning or just mirror folders?
- Could another context change its internals without breaking this one?
- Are shared terms truly shared, or only assumed to be shared?
- Is translation explicit where vocabularies differ?
- Is the modeling depth appropriate for the business importance of this context?
- Is the boundary earning its cost?

## Related docs

- `context/principles/02-ubiquitous-language-and-naming.md`
- `context/principles/04-workflows-invariants-and-state.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
