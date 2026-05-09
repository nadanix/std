# Workflow and State Modeling Playbook

## Summary

- Model workflows as business transformations with visible triggers, decisions, and outputs.
- Make states and transitions explicit when behavior changes over time.
- Separate domain decisions from edge effects.
- Use compact tables and pseudocode when they clarify the model.

## Use this when

- describing a business process
- defining allowed and forbidden state transitions
- documenting long-running or asynchronous behavior
- making invariants and failure modes explicit

## Inputs

- workflow name and purpose
- triggering inputs or events
- relevant concepts and invariants
- external dependencies, if any

## Steps

### 1. Name the workflow by business intent

Prefer names like `approve claim` or `place order` over technical labels.

### 2. Define trigger, inputs, and outputs

State:
- what starts the workflow
- what information it consumes
- what successful completion produces
- what explicit rejection or failure results may occur

### 3. List the important decisions

Capture the decision points that change outcomes, not every implementation detail.

### 4. Describe state transitions

If states matter, document:
- current state
- triggering action or event
- resulting state
- guard condition or invariant
- side effects at the edge

### 5. Separate core from edge actions

Mark which steps are:
- core domain decisions
- external reads or writes
- emitted messages or notifications
- operational protections such as retries or timeouts

### 6. Document failure modes

Classify failures as:
- domain-significant
- contract or input problems
- operational failures

### 7. Note long-running concerns if present

Document waiting states, retries, duplicate handling, time windows, and compensations if needed.

## Example transition table

| From | Trigger | Guard | To | Notes |
|---|---|---|---|---|
| pending | payment confirmed | order still valid | paid | emit confirmation at edge |
| pending | validation failed | invalid request | rejected | rejection is explicit |
| paid | shipping requested | inventory allocated | fulfillable | downstream action may follow |

## Example workflow skeleton

```text
Workflow: Approve Claim
Trigger: claimant submits a complete claim
Input: claim identity, policy context, supporting evidence
Output: approved claim or explicit claim rejection

Core steps:
1. verify claim eligibility
2. classify supporting evidence
3. decide approval or rejection
4. classify result as success or failure

Edge steps:
5. persist resulting state
6. emit claim outcome
```

## Review questions

- Can the workflow be understood without implementation details?
- Are states and transition guards explicit enough to review?
- Are edge effects separated from core decisions?
- Are long-running concerns documented where relevant?

## Related docs

- `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
- `context/principles/04-workflows-invariants-and-state.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/review/02-architecture-review-checklist.md`
