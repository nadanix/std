# Playbooks Map

This directory contains task-oriented guidance for applying the framework.

## How to use this directory

### If you need to shape a domain model
Read:
1. `context/playbooks/01-domain-modeling-playbook.md`
2. `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
3. `context/principles/02-ubiquitous-language-and-naming.md`
4. `context/principles/03-bounded-contexts-and-boundaries.md`

### If you need to discover business events or build an event catalog
Read:
1. `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
2. `context/principles/04-workflows-invariants-and-state.md`
3. `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md` if events cross context boundaries

### If you need to model trusted vs untrusted data
Read:
1. `context/playbooks/05-trusted-and-untrusted-representations-playbook.md`
2. `context/principles/07-type-shaped-models-and-illegal-states.md`

### If you need to classify entities, value objects, or aggregates
Read:
1. `context/playbooks/06-entity-value-object-and-aggregate-design-playbook.md`
2. `context/principles/08-entities-value-objects-and-aggregates.md`

### If you need to define a bounded context
Read:
1. `context/playbooks/02-bounded-context-definition-playbook.md`
2. `context/principles/03-bounded-contexts-and-boundaries.md`

### If you need to model workflow behavior, failure meaning, or states
Read:
1. `context/playbooks/03-workflow-and-state-modeling-playbook.md`
2. `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
3. `context/principles/04-workflows-invariants-and-state.md`
4. `context/principles/09-workflow-pipelines-effects-and-dependencies.md`

### If you need to design cross-context contracts or anti-corruption seams
Read:
1. `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
2. `context/principles/03-bounded-contexts-and-boundaries.md`
3. `context/principles/10-serialization-persistence-and-data-ownership.md`

### If you need to design persistence and mapping boundaries
Read:
1. `context/playbooks/07-persistence-and-mapping-boundaries-playbook.md`
2. `context/principles/10-serialization-persistence-and-data-ownership.md`

### If you need to record a structural decision
Read:
1. `context/playbooks/04-adr-writing-playbook.md`
2. `context/review/01-quality-gates.md`

## Documents

- `01-domain-modeling-playbook.md`
  - step-by-step domain discovery and artifact creation
- `02-bounded-context-definition-playbook.md`
  - how to define a bounded context and its seam contracts
- `03-workflow-and-state-modeling-playbook.md`
  - how to model behavior, states, invariants, and failure modes
- `04-adr-writing-playbook.md`
  - how to capture a meaningful architectural decision
- `05-trusted-and-untrusted-representations-playbook.md`
  - how to move raw inputs into trusted domain representations
- `06-entity-value-object-and-aggregate-design-playbook.md`
  - how to classify concepts and choose aggregate boundaries
- `07-persistence-and-mapping-boundaries-playbook.md`
  - how to keep storage and wire shapes from owning the model
- `08-business-event-discovery-and-event-catalog-playbook.md`
  - how to extract business events and turn them into reusable event catalogs
- `09-domain-error-and-failure-taxonomy-playbook.md`
  - how to classify failures by meaning and expose stable failure surfaces
- `10-cross-context-contract-and-anti-corruption-playbook.md`
  - how to document contracts, ownership, and translation seams between contexts

## Directory rules

- explain what to do, not all theory behind why
- assume principles are authoritative and link to them
- prefer compact checklists and tables over long essays
- update the playbooks manifest when adding or renaming playbooks

## Related docs

- `context/manifests/playbooks-manifest.yaml`
- `context/principles/00-map.md`
- `context/review/00-map.md`
