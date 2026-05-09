# Patterns Map

This directory contains reusable solution shapes that sit between principles and playbooks.

## How to use this directory

### If you are comparing decomposition choices
Read:
1. `context/patterns/01-boundary-and-decomposition-patterns.md`
2. `context/principles/03-bounded-contexts-and-boundaries.md`

### If you are shaping workflow behavior
Read:
1. `context/patterns/02-workflow-and-state-transition-patterns.md`
2. `context/principles/04-workflows-invariants-and-state.md`

### If you are defining failure handling and edge seams
Read:
1. `context/patterns/03-error-and-edge-translation-patterns.md`
2. `context/principles/05-errors-and-edge-responsibilities.md`

## Documents

- `01-boundary-and-decomposition-patterns.md`
  - recurring ways to partition ownership, language, and translation seams
- `02-workflow-and-state-transition-patterns.md`
  - recurring workflow, state, and long-running behavior shapes
- `03-error-and-edge-translation-patterns.md`
  - recurring ways to classify failures and isolate edge concerns

## Directory rules

- patterns should describe reusable shapes, not absolute rules
- patterns should link back to the principles they depend on
- patterns should stay more comparative than playbooks
- update the patterns manifest when adding or renaming docs

## Related docs

- `context/manifests/patterns-manifest.yaml`
- `context/principles/00-map.md`
- `context/playbooks/00-map.md`
