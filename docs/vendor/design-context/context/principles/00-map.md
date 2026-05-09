# Principles Map

This directory holds the canonical rules for the framework.

## How to use this directory

Read the smallest subset that matches the task.

### If you are shaping the repository itself
Read:
1. `01-information-architecture-and-manifests.md`
2. `06-deep-modules-and-information-hiding.md`

### If you are modeling a domain deeply
Read:
1. `02-ubiquitous-language-and-naming.md`
2. `07-type-shaped-models-and-illegal-states.md`
3. `08-entities-value-objects-and-aggregates.md`
4. `03-bounded-contexts-and-boundaries.md`

### If you are modeling workflows and effects
Read:
1. `04-workflows-invariants-and-state.md`
2. `09-workflow-pipelines-effects-and-dependencies.md`
3. `05-errors-and-edge-responsibilities.md`

### If you are integrating persistence or evolving the model
Read:
1. `10-serialization-persistence-and-data-ownership.md`
2. `11-evolving-models-through-change.md`

### If you are reviewing proposed changes
Read:
1. `01-information-architecture-and-manifests.md`
2. `05-errors-and-edge-responsibilities.md`
3. `06-deep-modules-and-information-hiding.md`

## Documents

- `01-information-architecture-and-manifests.md`
  - file and directory responsibilities, load order, size budgets, manifest conventions
- `02-ubiquitous-language-and-naming.md`
  - vocabulary-first design and naming rules
- `03-bounded-contexts-and-boundaries.md`
  - how to partition models and define seams between them
- `04-workflows-invariants-and-state.md`
  - how to model behavior, state transitions, and constraints
- `05-errors-and-edge-responsibilities.md`
  - how to make failure modes explicit and keep edge concerns at the edges
- `06-deep-modules-and-information-hiding.md`
  - how to keep the knowledge base deep, compact, and low-friction to retrieve
- `07-type-shaped-models-and-illegal-states.md`
  - how trusted representations and narrow types keep domain meaning explicit
- `08-entities-value-objects-and-aggregates.md`
  - how to distinguish identity, value, and consistency boundaries
- `09-workflow-pipelines-effects-and-dependencies.md`
  - how to compose workflows from explicit steps, effects, and dependencies
- `10-serialization-persistence-and-data-ownership.md`
  - how to keep storage and transport from owning the model
- `11-evolving-models-through-change.md`
  - how to revisit the model first when requirements change

## Directory rules

- keep one abstraction level per file
- summarize first, elaborate second
- treat these files as canonical over downstream summaries or ad hoc guidance
- prefer links to duplication
- update `context/manifests/principles-manifest.yaml` when adding or renaming docs

## Related docs

- `context/00-map.md`
- `context/manifests/project-manifest.yaml`
- `context/manifests/principles-manifest.yaml`
- `context/playbooks/00-map.md`
- `context/review/00-map.md`
