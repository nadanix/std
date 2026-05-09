# ADR 0005: Core Context Pack and Vendoring Boundary

- Status: Accepted
- Date: 2026-04-27

## Context

Third-party repositories need a consistent way to consume this framework. Copying the whole source repository brings along maintenance machinery, while copying only `context/**` can omit entrypoints, ADR rationale, and license information.

Agent-first repositories increasingly use `docs/` as the local, versioned system of record for maps, domain notes, ADRs, and review artifacts. A vendored framework should be easy for agents to discover there without becoming indistinguishable from project-specific documentation.

Export automation remains intentionally deferred, so manual vendoring needs an explicit boundary and preferred location.

## Decision

Define the default vendored artifact as a **core context pack** containing:

```text
LICENSE
README.md
AGENTS.md
VENDORING.md
context/**
docs/adr/**
```

Prefer this consumer location when the repo has a `docs/` directory:

```text
docs/vendor/design-context/
```

Allow fallback locations when the consumer repo does not use `docs/`:

```text
vendor/design-context/
third_party/design-context/
```

Do not vendor source-repository machinery by default:

```text
.git/**
.github/**
.pi/**
tooling/**
CONTRIBUTING.md
vision.md
docs/research/**
docs/repository-plan.md
docs/publication-and-maintenance.md
*.epub
```

Manual vendoring of this core pack is the supported consumption path until export automation is justified.

## Rationale

The core pack keeps the consumer-facing surface self-contained:

- `README.md`, `AGENTS.md`, and `context/00-map.md` provide entrypoints.
- `context/**` contains canonical principles, patterns, playbooks, glossary, review docs, and manifests.
- `docs/adr/**` preserves structural rationale without pulling in research or publication machinery.
- `LICENSE` keeps reuse legally clear.

Placing the pack under `docs/vendor/` when possible aligns with agent-first repository patterns:

- the repo-local `docs/` tree becomes the discoverable knowledge store
- `AGENTS.md` can stay short and act as a table of contents
- project-specific docs can override generic vendored guidance without editing the vendored pack
- the `vendor/` segment still marks the framework as copied upstream material

This matches the repository's progressive-disclosure model while avoiding accidental dependency on source-only tooling or local backlog state.

## Consequences

### Positive

- third-party vendoring has a single expected shape and preferred location
- consumer repos avoid CI, tooling, backlog, and research noise
- agents are more likely to find the framework inside the consumer repo's `docs/` knowledge store
- the vendored pack remains usable without the full source checkout
- future exporters can target the same boundary

### Negative

- source-repo research notes are not available in the default consumer pack
- manual copying is still required until export automation exists
- consumer repos without `docs/` need a fallback location
- root docs must stay careful not to depend on source-only files for normal use

## Rules implied by this ADR

- prefer `docs/vendor/design-context/` for third-party vendoring when `docs/` exists
- keep the default load path inside the core context pack
- keep consumer `AGENTS.md` short and map-like; do not paste the framework into it
- place consumer-specific adaptations outside the vendored directory
- do not add references from core docs to source-only maintenance files unless clearly marked as source-only
- preserve `VENDORING.md` when changing consumption policy
- future export tooling should derive from canonical docs, not create a parallel source of truth
