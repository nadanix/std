# Documentation Quality Checklist

## Summary

- Good docs are discoverable, scoped, consistent, and independently readable.
- This checklist helps prevent giant, vague, or duplicative documents.
- Use it for new docs and for refactors of existing docs.

## Use this when

- reviewing new markdown artifacts
- deciding whether to split or merge a document
- checking whether a doc is ready to become canonical

## Checklist

### Purpose and scope

- [ ] the title matches the actual purpose
- [ ] the summary tells the reader what the doc is for
- [ ] the "load this when" or equivalent usage guidance is clear
- [ ] the intended impact is clear before detail is added
- [ ] the scope is narrow enough to stay focused

### Structure

- [ ] one abstraction level is maintained throughout the file
- [ ] sections are easy to scan
- [ ] tables, lists, or checklists are used where they reduce ambiguity
- [ ] related docs are linked instead of repeating the same rule

### Discoverability

- [ ] the doc is linked from the nearest map
- [ ] the nearest manifest is updated if the doc is canonical
- [ ] a reader can infer what to read next

### Maintainability

- [ ] the file is within intended size budgets or has a clear reason not to be
- [ ] wording is consistent with nearby canonical docs
- [ ] no downstream summary has become the hidden source of truth
- [ ] important structural changes are captured in an ADR when needed

### Vocabulary

- [ ] glossary-aligned terms are used
- [ ] aliases are explicit rather than accidental
- [ ] no obvious vocabulary drift is present

## Related docs

- `context/review/01-quality-gates.md`
- `context/review/04-vocabulary-drift-checklist.md`
- `context/principles/06-deep-modules-and-information-hiding.md`
