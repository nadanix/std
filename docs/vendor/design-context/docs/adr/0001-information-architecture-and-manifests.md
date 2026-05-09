# ADR 0001: Information Architecture and Manifest Shape

- Status: Accepted
- Date: 2026-04-10

## Context

This repository is intended to grow into a large reusable context framework. Without deliberate structure, it would become expensive for agents to navigate under limited context windows.

## Decision

Adopt a layered information architecture with:

1. small root docs
2. map files as navigation entrypoints
3. canonical principle docs as the main source of truth
4. machine-readable manifests for retrieval
5. ADRs for structural decisions
6. review artifacts for quality gates and checklists

Use YAML manifests with simple stable keys, and require map + manifest updates whenever canonical files are added, moved, or removed.

## Rationale

This decision combines:

- the modular, path-aware strengths of `tenets`
- the domain-centered explicitness emphasized in _Domain Modeling Made Functional_
- the deep-module and information-hiding principles from _A Philosophy of Software Design_

## Consequences

### Positive

- cheaper retrieval for agents
- clearer separation of abstraction layers
- lower duplication risk
- easier future automation and linting

### Negative

- slightly more authoring discipline is required
- adding docs now often requires updating multiple navigation artifacts
- the repository needs periodic structural review to stay compact

## Rules implied by this ADR

- each major context area should have a small map
- canonical areas should have a manifest or a parent manifest entry
- maps, principles, patterns, playbooks, and review docs must stay at different abstraction levels
- canonical guidance should remain compact enough for selective loading
