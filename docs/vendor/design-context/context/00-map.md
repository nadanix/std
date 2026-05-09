# Context Map

This file is the main navigation entrypoint for the framework.

## Default load order

1. `README.md`
2. `context/00-map.md`
3. `context/manifests/project-manifest.yaml`
4. the nearest area map or manifest
5. the smallest relevant leaf docs
6. ADRs if trade-offs are needed

## Quick start by task

### Shape or refactor the repository
Read:
1. `context/principles/01-information-architecture-and-manifests.md`
2. `context/principles/06-deep-modules-and-information-hiding.md`
3. `docs/adr/0001-information-architecture-and-manifests.md`

### Vendor or consume this framework in another repo
Read:
1. `VENDORING.md`
2. `context/manifests/project-manifest.yaml`
3. `docs/adr/0005-core-context-pack-and-vendoring-boundary.md`

### Compare reusable design shapes
Read:
1. `context/patterns/00-map.md`
2. the smallest relevant pattern doc for boundaries, workflows, or errors

### Model a domain deeply
Read:
1. `context/playbooks/01-domain-modeling-playbook.md`
2. `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
3. `context/principles/07-type-shaped-models-and-illegal-states.md`
4. `context/principles/08-entities-value-objects-and-aggregates.md`
5. `context/principles/03-bounded-contexts-and-boundaries.md`

### Discover business events or build an event catalog
Read:
1. `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
2. `context/principles/04-workflows-invariants-and-state.md`
3. `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md` if events cross context boundaries

### Model workflow behavior, effects, or state changes
Read:
1. `context/principles/04-workflows-invariants-and-state.md`
2. `context/principles/09-workflow-pipelines-effects-and-dependencies.md`
3. `context/playbooks/03-workflow-and-state-modeling-playbook.md`
4. `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`

### Define cross-context contracts or translation seams
Read:
1. `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
2. `context/principles/03-bounded-contexts-and-boundaries.md`
3. `context/principles/10-serialization-persistence-and-data-ownership.md`

### Integrate persistence or revisit data ownership
Read:
1. `context/principles/10-serialization-persistence-and-data-ownership.md`
2. `context/playbooks/07-persistence-and-mapping-boundaries-playbook.md`
3. `context/patterns/03-error-and-edge-translation-patterns.md`

### Evolve the model after requirement changes
Read:
1. `context/principles/11-evolving-models-through-change.md`
2. `context/playbooks/04-adr-writing-playbook.md`
3. the nearest affected principle, playbook, or review checklist

### Review docs or designs
Read:
1. `context/review/01-quality-gates.md`
2. `context/review/03-documentation-quality-checklist.md`
3. `context/review/04-vocabulary-drift-checklist.md`
4. `context/review/05-event-and-contract-artifact-checklist.md`

For reviews, start with the review checklist layer. Load principle or playbook docs only when a finding needs canonical grounding.

## Areas

### `principles/`
Canonical rules and stable design tenets.

Entry docs:
- `context/principles/00-map.md`
- `context/manifests/principles-manifest.yaml`

### `patterns/`
Reusable structures and comparative solution shapes.

Entry docs:
- `context/patterns/00-map.md`
- `context/manifests/patterns-manifest.yaml`

### `glossary/`
Vocabulary and naming guidance.

Entry docs:
- `context/glossary/00-map.md`
- `context/manifests/glossary-manifest.yaml`

### `playbooks/`
Task-oriented guidance.

Entry docs:
- `context/playbooks/00-map.md`
- `context/manifests/playbooks-manifest.yaml`

### `review/`
Checklists and quality gates.

Entry docs:
- `context/review/00-map.md`
- `context/manifests/review-manifest.yaml`

### `manifests/`
Machine-readable retrieval metadata.

Current entry docs:
- `context/manifests/README.md`
- `context/manifests/project-manifest.yaml`

## Authoring rules for this directory

- one file, one abstraction level
- summary first
- link instead of duplicating
- prefer tables, checklists, and state descriptions over long prose
- update maps and manifests when adding, removing, or renaming canonical docs
