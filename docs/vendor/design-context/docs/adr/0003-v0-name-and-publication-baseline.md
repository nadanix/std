# ADR 0003: v0 Name and Publication Baseline

- Status: Accepted
- Date: 2026-04-10

## Context

The repository has reached a coherent v0 shape and needs a stable publication baseline for naming, maintenance, and future sharing.

The name should follow the repository's own naming guidance: it should be meaning-bearing, concise, tool-neutral, and aligned with the core purpose of providing reusable design context.

## Decision

For v0, use the repository name **`design-context`**.

Also adopt the following publication baseline:

1. add contribution guidance
2. add CI that runs the lightweight repository checks
3. keep agent-specific export generation deferred until reuse patterns justify it
4. keep the core framework compact and canonical

## Rationale

`design-context` makes the repository's purpose explicit: a reusable context pack for software design, domain modeling, workflows, architecture review, and related decisions.

The name is intentionally:
- short enough for vendored paths such as `docs/vendor/design-context/`
- broad enough to cover architecture, DDD, workflow modeling, and review
- independent of a specific agent tool, model provider, language, or runtime
- aligned with the framework's naming rules for meaning-bearing artifacts

The publication baseline emphasizes maintainability over premature packaging automation.

## Consequences

### Positive

- the repo now has a stable v0 identity
- the name is shorter and more meaning-bearing
- contribution and review expectations are clearer
- CI protects the structure from silent drift
- the project avoids overcommitting to export automation too early

### Negative

- future branding may still revisit the name
- agent-specific export convenience remains deferred for now

## Rules implied by this ADR

- treat `design-context` as the v0 public name unless a later ADR changes it
- use `docs/vendor/design-context/` as the preferred vendored path in consumer repositories with `docs/`
- keep CI lightweight and aligned with local checks
- preserve a small canonical core before adding distribution conveniences
