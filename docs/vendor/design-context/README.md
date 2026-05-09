# design-context

> Reusable, language-agnostic AI agent context framework for DDD, workflows, patterns, and review checklists.

> Previously developed under a temporary working name. The canonical public repository name is now **`design-context`**.

## Why this repository exists

This repository is meant to be a personal, reusable alternative to [bardiakhosravi/tenets](https://github.com/bardiakhosravi/tenets): a place to store opinionated context that AI agents can load when designing, reviewing, and evolving software systems.

The goal is broader than the original project:

- **language agnostic first**
- focused on **architecture, domain modeling, workflows, and quality**
- optimized for **agent consumption under limited context windows**
- reusable across **multiple languages, stacks, and project types**

## Repo identity at a glance

- **Canonical name:** `design-context`
- **Public repo:** `https://github.com/oneingan/design-context`
- **Default agent load order:** `README.md` → `context/00-map.md` → `context/manifests/project-manifest.yaml`
- **Default vendored path in consumer repos:** `docs/vendor/design-context/`
- **Do not load by default:** source-repo tooling, research notes, publication notes, or other source-only maintenance material

## How to consume this repo

Use this repository with **progressive disclosure**. Do not load the whole corpus unless explicitly asked.

Start with:

1. `README.md`
2. `context/00-map.md`
3. `context/manifests/project-manifest.yaml`

For third-party vendoring, copy the core context pack described in `VENDORING.md`. Prefer `docs/vendor/design-context/` in consumer repos that have a `docs/` knowledge store:

```text
LICENSE
README.md
AGENTS.md
VENDORING.md
context/**
docs/adr/**
```

Do not vendor source-repository machinery such as CI, tooling, local backlog, research notes, or publication notes by default. Keep the consumer repo's `AGENTS.md` short and point it at the vendored pack instead of pasting the framework into it.

## Main design inputs

This repo is being designed from three main sources:

1. **Upstream inspiration: `tenets`**
   - layered context packs
   - task-specific guidance
   - path-aware loading for agents
   - architecture review mindset

2. **Scott Wlaschin — _Domain Modeling Made Functional_**
   - ubiquitous language
   - bounded contexts
   - explicit invariants and state transitions
   - workflow/pipeline thinking
   - domain events, contracts, and edge-bound persistence

3. **John Ousterhout — _A Philosophy of Software Design_**
   - strategic programming
   - deep modules
   - information hiding
   - error prevention over error handling
   - comments, naming, and ADRs as design tools

## Repository stance

The canonical layer should be mostly:

- prose principles
- reusable patterns
- glossaries and naming rules
- playbooks and checklists
- decision records
- manifests and schemas
- maps and review artifacts

Keep any illustrative material small, local to the canonical document that needs it, and subordinate to the rule or playbook it clarifies.

## Canonical layers

- `context/principles/00-map.md` — canonical design rules
- `context/patterns/00-map.md` — reusable solution shapes
- `context/glossary/00-map.md` — vocabulary and naming governance
- `context/playbooks/00-map.md` — task-oriented procedures
- `context/review/00-map.md` — quality gates and checklists
- `context/manifests/project-manifest.yaml` — machine-readable retrieval map

## Architecture decisions

- `docs/adr/0001-information-architecture-and-manifests.md` — structural decision for maps/manifests/layers
- `docs/adr/0002-lightweight-validation-before-agent-exports.md` — tooling and export strategy
- `docs/adr/0003-v0-name-and-publication-baseline.md` — v0 naming and publication baseline
- `docs/adr/0004-license-choice.md` — repository license choice
- `docs/adr/0005-core-context-pack-and-vendoring-boundary.md` — third-party vendoring boundary

## Success criteria

A good release should let an agent:

1. understand the framework without loading the whole repo
2. find the right context by topic and task
3. reason about domains, boundaries, events, contracts, workflows, and failures in a language-neutral way
4. apply the framework to a new project with minimal adaptation
5. evolve over time through ADRs, manifests, and small focused documents

## Current status

The repository now includes:

- ADRs for information architecture, tooling strategy, publication baseline, license choice, and vendoring boundary
- canonical principles derived from the source books
- reusable patterns for boundaries, workflows, and errors
- glossary and naming governance
- playbooks for domain modeling, boundaries, workflows, trusted data, aggregate design, persistence boundaries, business event discovery, failure taxonomy, and cross-context contracts
- review checklists and repo quality gates, including event/contract artifact review
- lightweight source-repo validation scripts for manifests and doc budgets

## Recommended next steps

- apply the core context pack to an external project and watch for missing guidance
- revisit export automation later if manual vendoring becomes painful
- keep the core compact and canonical before adding new distribution formats

## Release status

- current release after repository rename and packaging cleanup: **v0.3.0**
- prior tags: `v0.1.0`, `v0.2.0`
