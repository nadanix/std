# Review Map

This directory contains evaluation artifacts for the framework.

## How to use this directory

### For repo-wide acceptance checks
Read:
1. `01-quality-gates.md`

### For design and architecture review
Read:
1. `context/review/02-architecture-review-checklist.md`
2. `context/principles/00-map.md`

### For documentation quality review
Read:
1. `03-documentation-quality-checklist.md`

### For naming and vocabulary drift review
Read:
1. `context/review/04-vocabulary-drift-checklist.md`
2. `context/glossary/01-framework-glossary.md`

### For event, trust-boundary, and contract artifact review
Read:
1. `context/review/05-event-and-contract-artifact-checklist.md`
2. `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
3. `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`

## Documents

- `01-quality-gates.md`
  - repo-level acceptance criteria for canonical changes
- `02-architecture-review-checklist.md`
  - evaluates boundaries, workflows, errors, contracts, and retrieval structure
- `03-documentation-quality-checklist.md`
  - evaluates clarity, abstraction, discoverability, and maintenance quality
- `04-vocabulary-drift-checklist.md`
  - evaluates naming consistency and term stability
- `05-event-and-contract-artifact-checklist.md`
  - evaluates event catalogs, trust-boundary notes, and cross-context contract artifacts

## Directory rules

- review artifacts should be actionable and scannable
- use checklists and pass/fail questions over long essays
- align checks with canonical principles and ADRs
- update the review manifest when adding or renaming docs

## Related docs

- `context/manifests/review-manifest.yaml`
- `context/glossary/00-map.md`
- `context/playbooks/04-adr-writing-playbook.md`
