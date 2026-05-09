# Workflows, Invariants, and State

## Summary

- Model behavior as explicit transformations, not as hidden side effects.
- Make inputs, outputs, decisions, and state transitions visible.
- Invariants are part of the model and must be documented where they matter.
- Separate workflow steps from the technologies used to execute them.
- Use state descriptions, tables, and pseudocode when types alone are unavailable.

## Load this when

- designing a business workflow
- describing a lifecycle or state machine
- deciding how to capture invariants
- reviewing whether behavior is explicit enough

## Principle

A workflow is a meaningful sequence of domain steps that turns one business situation into another. Good models make the progression visible: what starts the workflow, which rules apply, what can fail, which states are allowed, and what outputs or events emerge.

## Workflow modeling rules

### 1. Define the workflow in terms of business change

Describe:
- triggering input
- important intermediate decisions
- resulting outputs or effects
- visible state changes

Start from the business story, not from controller methods or database operations.

### 2. Make state transitions explicit

If an entity or process changes over time, document:
- states
- allowed transitions
- forbidden transitions
- transition conditions
- resulting side effects or emitted facts

### 3. Treat invariants as first-class constraints

An invariant is something that must always be true within a scope.

Examples:
- an approved order must have at least one line
- a booking cannot be confirmed after cancellation
- an entitlement cannot be active outside its validity window

Document invariants near the workflow or state they govern.

### 4. Separate decision logic from side effects

A workflow often contains both:
- domain decisions
- edge actions such as persistence, messaging, or external calls

Model these separately so the decision path stays understandable even if the execution environment changes.

### 5. Prefer structured representations for complex behavior

When a workflow is non-trivial, use one or more of:
- step lists
- state tables
- decision tables
- input/output schemas
- short pseudocode focused on business intent

### 6. Be explicit about long-running workflows

For long-running or asynchronous workflows, document:
- checkpoints
- waiting states
- retry or timeout conditions
- idempotency or duplicate-handling expectations
- compensating or recovery paths if relevant

### 7. Keep workflow names intention-revealing

Prefer names like:
- place order
- approve claim
- approve claim

Avoid names that mainly reflect technical implementation.

## Minimum workflow description

A canonical workflow description should usually include:

1. purpose
2. trigger
3. inputs
4. outputs
5. ordered steps or transitions
6. invariants
7. failure modes
8. external dependencies, if any

## Minimal workflow structure

```text
Workflow: Place Order
Trigger: customer submits a valid order request
Input: order request
Output: accepted order or explicit rejection

Steps:
1. validate request shape
2. translate into domain terms
3. check product and pricing rules
4. decide acceptance or rejection
5. persist accepted state at the edge
6. emit resulting facts or notifications at the edge

Invariants:
- accepted orders contain at least one valid line
- totals are derived from validated line data
- rejected orders do not transition to fulfilled
```

## Review questions

- Is the business change clear without reading implementation code?
- Are allowed and forbidden transitions visible?
- Are invariants documented where readers need them?
- Could the workflow be understood if the transport or database changed?
- Are long-running behaviors explicit rather than implied?

## Related docs

- `context/principles/03-bounded-contexts-and-boundaries.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/playbooks/03-workflow-and-state-modeling-playbook.md`
