# Workflow and State Transition Patterns

## Summary

- Workflows become easier to reason about when they use repeatable shapes.
- These patterns help distinguish business decision flow from execution detail.
- They are especially useful for long-running behavior and explicit state transitions.
- Use them to compare modeling options before writing detailed workflow guidance.

## Load this when

- choosing how to describe a workflow
- deciding whether a state model is needed
- comparing short-lived and long-running behavior shapes

## Pattern 1: Validate → Decide → Transition → Emit

### Use when
A workflow turns an input into a domain outcome with explicit state change.

### Shape
1. validate or classify input
2. make the domain decision
3. perform the state transition
4. emit the resulting outcome or request edge actions

### Benefits
- keeps business meaning visible
- separates decision from reaction

### Risks
- may look more formal than needed for trivial cases

## Pattern 2: Pending External Result

### Use when
A workflow must wait for an external outcome before the domain can complete.

### Shape
- enter a pending state
- wait for the external result
- translate the result into domain meaning
- continue the workflow from there

### Benefits
- long-running behavior is explicit
- retries and time windows can be modeled cleanly

### Risks
- hidden assumptions accumulate if the pending state is not documented carefully

## Pattern 3: Grace Window Recovery

### Use when
Failure does not immediately become a terminal business outcome.

### Shape
- failure moves the model into a temporary recovery state
- recovery remains allowed until a clear boundary condition expires
- after that, a terminal outcome is applied

### Benefits
- maps well to real business tolerance and retry rules
- prevents false binary modeling

### Risks
- ambiguous deadlines if the grace rules are vague

## Pattern 4: State Table First

### Use when
A lifecycle has several allowed and forbidden transitions.

### Shape
- define a compact transition table first
- add narrative or pseudocode only after the state surface is clear

### Benefits
- exposes gaps and contradictions early
- easy for agents to scan under tight context

### Risks
- can oversimplify when the surrounding workflow meaning is not also documented

## Pattern 5: Outcome Then Notification

### Use when
A business outcome must be communicated externally.

### Shape
- first decide the business outcome
- then emit a stable outcome for downstream communication
- keep notification delivery separate from deciding the business result

### Benefits
- prevents communication tooling from deciding domain meaning
- makes downstream adapters replaceable

### Risks
- if the emitted outcome is vague, downstream consumers may re-interpret it inconsistently

## Related docs

- `context/principles/04-workflows-invariants-and-state.md`
- `context/playbooks/03-workflow-and-state-modeling-playbook.md`
- `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
