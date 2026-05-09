# Error and Edge Translation Patterns

## Summary

- Failures should become simpler and more stable as they move inward.
- Edge details belong close to the boundary where they arise.
- These patterns help preserve domain meaning while still acknowledging operational reality.
- Use them when deciding how to classify, translate, and surface failures.

## Load this when

- defining failure categories
- deciding where retries or translations should live
- reviewing whether edge concerns are leaking inward

## Pattern 1: Classify at the Boundary

### Use when
An external input or dependency can fail in many detailed ways.

### Shape
- classify the detailed outcome where it first appears
- collapse it into a smaller stable set of categories
- pass inward only the categories the domain actually cares about

### Benefits
- protects the core model from vendor or protocol churn
- makes failure handling easier to review

### Risks
- over-collapsing can hide distinctions that matter for recovery

## Pattern 2: Translate Before Inward Flow

### Use when
A foreign concept or error label should not become part of the core language.

### Shape
- translate external terms into domain-relevant terms before they cross inward
- keep the original detail at the edge for logging or diagnostics only

### Benefits
- preserves ubiquitous language
- prevents technical labels from colonizing the model

### Risks
- poor translation can create a misleadingly simple picture

## Pattern 3: Stable Failure Envelope

### Use when
Multiple callers or downstream contexts need a consistent failure surface.

### Shape
- expose a small stable envelope of failure categories
- keep local implementation details hidden behind it

### Benefits
- easier integration and review
- lower coupling to internal churn

### Risks
- can become too generic if not anchored in actual meaning

## Pattern 4: Domain Decision, Edge Retry

### Use when
A workflow allows retry, but the mechanics of retry belong at the edge.

### Shape
- the domain decides whether retry is allowed
- the edge schedules or executes the retry
- the edge reports results back through a stable seam

### Benefits
- keeps retry eligibility in business language
- keeps schedulers and queues out of the core model

### Risks
- if the seam is vague, the edge may overstep and start making domain decisions

## Pattern 5: Unexpected Outcome Quarantine

### Use when
An outcome arrives that is valid at the protocol level but unexpected in the current domain state.

### Shape
- classify the event as unexpected or out-of-sequence
- avoid silently forcing a normal transition
- surface it for explicit review or recovery handling

### Benefits
- prevents hidden corruption of the model
- makes abnormal paths auditable

### Risks
- can create operational noise if overused for harmless cases

## Related docs

- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/playbooks/03-workflow-and-state-modeling-playbook.md`
- `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
