# Trusted and Untrusted Representations Playbook

## Summary

- Model the transition from raw input to trusted domain data explicitly.
- Use named stages so readers can see where trust is earned.
- Keep validation close to construction instead of scattering checks everywhere.
- Carry units, ranges, precision, and measurement meaning into the trusted representation when relevant.
- Record which failures belong to parsing, contract, or domain meaning.

## Use this when

- turning external input into trusted domain data
- reducing repeated defensive validation in the core
- deciding how to represent raw, parsed, and validated values

## Inputs

- external request or event shapes
- domain concepts and invariants
- known validation rules
- likely failure categories

## Steps

### 1. Identify untrusted entry points

List every place raw data enters the model.

Examples:
- HTTP requests
- CLI input
- queue messages
- database reads from older or weakly validated data
- third-party gateway responses

### 2. Define the trust stages

For each important concept, decide whether you need stages such as:
- raw
- parsed or classified
- validated
- trusted domain representation

Not every concept needs every stage, but important boundaries should be visible.

### 3. Name the trusted representation

Prefer names that show meaning clearly.

Examples:
- `UnvalidatedOrder` → `ValidatedOrder`
- `RawProviderOutcome` → `ClassifiedPaymentOutcome`
- `RenewalRequestPayload` → `RenewalCommand`
- `RawQuantity` → `MeasuredQuantity`

### 4. Keep validation near construction

Define where the move into trusted form happens.

Ask:
- what checks happen here?
- what assumptions become safe afterwards?
- what units, ranges, or precision rules become explicit?
- what invalid states are now prevented?

### 5. Classify failures by boundary meaning

Distinguish:
- parse or shape failures
- contract failures
- domain-significant rejections
- operational failures

### 6. Record the trusted/untrusted flow

Create a short table or note showing:
- source shape
- transition rule
- trusted target shape
- failure categories

## Output shape

| Source | Transition | Trusted target | Failure categories |
|---|---|---|---|
| raw order request | parse + validate | order command | malformed request, invalid item |
| raw provider outcome | classify + translate | payment outcome | unknown category, provider timeout |

## Review questions

- Where does raw input become trusted?
- Are units, ranges, and precision explicit before the value is trusted?
- Are trusted representations named distinctly enough?
- Which checks still repeat unnecessarily after trust is established?
- Are failure categories clear at the trust boundary?

## Related docs

- `context/principles/07-type-shaped-models-and-illegal-states.md`
- `context/principles/05-errors-and-edge-responsibilities.md`
- `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
