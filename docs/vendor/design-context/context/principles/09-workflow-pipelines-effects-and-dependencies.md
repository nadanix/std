# Workflow Pipelines, Effects, and Dependencies

## Summary

- Model workflows as assembled sequences of explicit steps.
- Each step should have a visible purpose, input surface, output surface, and effect surface.
- Keep pure decision steps distinct from effectful edge interactions where possible.
- Treat dependencies as part of workflow assembly, not hidden global facts.
- Make long-running waiting states and explicit error results part of the workflow surface.

## Load this when

- turning a workflow into an executable design
- deciding how to expose dependencies or effects
- modeling long-running flows
- clarifying where errors belong in the workflow surface

## Principle

DMMF's pipeline approach is valuable even outside functional languages. The durable lesson is that workflows become easier to understand when they are composed from explicit steps instead of hiding decisions, effects, and dependencies inside one opaque operation.

## Rules

### 1. Name the major steps of the workflow

A reader should be able to see the major transformations or decisions without tracing every implementation detail.

### 2. Distinguish pure steps from effectful steps

Where practical, separate:
- classification or validation
- domain decision
- state transition
- external call or persistence
- emitted outcomes

### 3. Make error results part of the workflow surface when they matter

If a failure changes business meaning, represent it explicitly in the workflow contract.

### 4. Treat dependencies as assembled inputs

Dependencies are not an afterthought. The act of wiring validators, gateways, repositories, clocks, or publishers is part of the design surface.

### 5. Keep long-running behavior explicit

If a workflow waits, retries, resumes, or times out, make that visible through states, step boundaries, or outcome categories.

### 6. Prefer composable steps over monolithic procedures

Smaller named steps make change impact clearer and reduce hidden coupling.

## Warning signs

Refactor when you see:
- one giant method or handler that mixes validation, decisions, persistence, and messaging
- dependencies accessed implicitly from everywhere
- error behavior that is only discoverable from exception code paths
- long-running behavior hidden inside infrastructure details

## Review questions

- Can the workflow be understood as a sequence of meaningful steps?
- Which steps are pure decisions and which are effects?
- Are dependencies visible where the workflow is assembled?
- Are long-running or waiting conditions explicit?

## Related docs

- `context/principles/04-workflows-invariants-and-state.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/patterns/02-workflow-and-state-transition-patterns.md`
- `context/playbooks/03-workflow-and-state-modeling-playbook.md`
