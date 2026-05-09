# Framework Glossary

## Summary

- This glossary stabilizes the core language of the repository.
- Use these terms consistently across maps, manifests, principles, playbooks, and review docs.
- If a term needs a new meaning, update the glossary before propagating the change.
- Local domain glossaries may extend this one, but should not silently contradict it.

## Load this when

- a term seems ambiguous
- you are authoring new canonical docs
- you want to align naming across artifacts
- you need a shared vocabulary for review

## Core terms

| Term | Meaning | Notes |
|---|---|---|
| agent context framework | A repository of reusable guidance that agents can load progressively to design, review, and evolve systems. | This repository's overall role. |
| canonical | The primary source of truth for a topic. | Canonical docs outrank downstream summaries or ad hoc guidance. |
| map | A navigation document that says what exists and what to read next. | Usually `00-map.md` or a local `README.md`. |
| manifest | Machine-readable retrieval metadata for an area. | Used for discovery and automation. |
| principle | A stable rule or design constraint. | Explains what is true or required. |
| pattern | A reusable solution shape with trade-offs. | Explains what tends to work. |
| playbook | A task-oriented procedure. | Explains what to do now. |
| glossary | A set of stable term definitions. | Keeps language aligned. |
| review artifact | A checklist, rubric, or gate used to evaluate proposed changes. | Review docs are evaluative, not explanatory. |
| ADR | Architecture Decision Record: a durable note of a structural decision, trade-offs, and consequences. | Use for meaningful design choices. |
| bounded context | The semantic scope within which a model and vocabulary are valid. | Boundary of meaning before technology. |
| strategic role | A context classification that guides modeling investment, such as core differentiator, supporting capability, or generic capability. | Optional; does not replace semantic boundaries. |
| workflow | A meaningful sequence of business steps that transforms one situation into another. | Should expose states, decisions, and outputs. |
| invariant | A condition that must remain true within a given scope. | Often tied to states or workflows. |
| edge concern | A transport, persistence, integration, serialization, or vendor-specific concern. | Keep these at the edges. |
| vocabulary drift | The gradual divergence of terms, meanings, or aliases across artifacts. | Review for this explicitly. |

## Scope rule

This glossary defines framework-level vocabulary. A future domain-specific glossary may add terms such as order, claim, renewal, or entitlement, but should not redefine framework terms casually.

## Alias rule

Aliases are allowed only when:
- the canonical term is explicit
- the alias exists for discovery or translation
- the alias does not silently replace the canonical term in the same scope

## Review questions

- Is the term already defined here?
- Is the same word being used with a different meaning elsewhere?
- Does the new term belong in the framework glossary or a domain-specific glossary?
- Is the canonical term obvious to both humans and agents?

## Related docs

- `context/glossary/02-naming-and-term-introduction.md`
- `context/principles/02-ubiquitous-language-and-naming.md`
- `context/review/04-vocabulary-drift-checklist.md`
