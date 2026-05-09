# ADR 0004: Use MIT License for v0

- Status: Accepted
- Date: 2026-04-10

## Context

The repository is ready for public publication, but it still needed an explicit license.

The project contains:
- framework documentation
- lightweight validation scripts
- repository maintenance metadata

A permissive license is desirable so the framework can be reused, adapted, and remixed in other repositories with minimal friction.

## Decision

License the repository under the **MIT License** for v0.

## Rationale

MIT is a good fit here because it:
- is simple and widely understood
- aligns well with reuse across many projects and stacks
- keeps friction low for documentation and helper scripts
- matches the permissive spirit of a reusable agent-context framework

## Consequences

### Positive

- easy reuse in personal and team repositories
- low legal friction for adaptation
- straightforward for public GitHub publication

### Negative

- provides fewer explicit patent-oriented guarantees than Apache-2.0
- may be viewed as overly minimal by organizations that prefer more detailed licensing terms

## Rules implied by this ADR

- treat MIT as the default repository license unless a later ADR changes it
- if future extracted packages need different licensing, document that explicitly rather than assuming inheritance
