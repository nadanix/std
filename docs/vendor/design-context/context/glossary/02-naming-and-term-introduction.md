# Naming and Term Introduction

## Summary

- Prefer one canonical term per concept within a scope.
- Name artifacts after business meaning first and technical mechanism second.
- Introduce new terms deliberately, not casually in passing prose.
- Record aliases and anti-terms instead of letting them spread informally.
- Every meaningful rename should trigger a vocabulary drift review.

## Load this when

- creating a new concept
- renaming a document, section, or model element
- deciding how to name files or repeatable artifact shapes
- reviewing ambiguity across artifacts

## Naming rules

### 1. Prefer meaning-bearing names

Choose names that answer what the artifact is for.

Prefer:
- `workflow-and-state-modeling-playbook.md`
- `errors-and-edge-responsibilities.md`

Over vague names like:
- `process-notes.md`
- `misc-rules.md`

### 2. Name by stable concept, not temporary implementation detail

Prefer domain or design meaning over transport or tool names unless the transport or tool is the topic.

### 3. Keep naming consistent across related artifacts

If a principle doc, a playbook, a review checklist, and a manifest entry refer to the same concept, they should use the same primary term.

### 4. Keep file names predictable

Use:
- numbered names for ordered canonical docs
- `00-map.md` for local navigation
- `*-manifest.yaml` for manifests
- specific names that support retrieval by topic

## Process for introducing a new term

1. **Check whether the concept already exists**
   - search nearby glossary, principle, and playbook docs first
2. **Choose the canonical term**
   - one preferred term per scope
3. **Write a short definition**
   - ideally one sentence
4. **Define the scope**
   - framework-wide, area-specific, or domain-specific
5. **Record aliases or anti-terms if needed**
   - note what people may say and what they should prefer instead
6. **Update the right discovery artifacts**
   - glossary first, then maps/manifests if canonical docs are added or renamed
7. **Run a vocabulary drift review**
   - use `context/review/04-vocabulary-drift-checklist.md`

## When to write an ADR for naming

Write an ADR when a naming decision:
- changes the meaning of a boundary or concept
- affects many artifacts across the repo
- resolves an important ambiguity that may recur later

## Anti-patterns

Avoid:
- silent renames with no glossary update
- multiple near-synonyms in the same scope
- technical placeholders becoming the canonical term by accident
- extra words that do not clarify the concept or scope
- names that only make sense if you already know the implementation

## Minimum rename checklist

- [ ] canonical term chosen
- [ ] definition updated
- [ ] aliases clarified
- [ ] affected docs updated
- [ ] manifest entries updated if needed
- [ ] vocabulary drift review completed
- [ ] ADR written if the rename is structurally important

## Related docs

- `context/glossary/01-framework-glossary.md`
- `context/principles/02-ubiquitous-language-and-naming.md`
- `context/review/04-vocabulary-drift-checklist.md`
