# Vendoring and Consumption Guide

## Summary

- Third-party repositories should vendor a **core context pack**, not the whole source repository.
- Prefer `docs/vendor/design-context/` when the consumer repo has a `docs/` directory.
- The core pack is the stable agent-readable product: root entrypoints, `context/**`, ADRs, and license.
- Source maintenance machinery stays outside consumer repositories unless the consumer is intentionally contributing to this repo.
- Manual vendoring is the current supported path until export automation is justified.

## Default vendored core pack

Copy these paths into one stable vendored directory:

```text
LICENSE
README.md
AGENTS.md
VENDORING.md
context/**
docs/adr/**
```

Preferred consumer location:

```text
docs/vendor/design-context/
```

Fallback locations when the consumer repo does not use `docs/`:

```text
vendor/design-context/
third_party/design-context/
```

The copied pack should remain self-contained for normal agent use. Start agents at:

1. `README.md`
2. `context/00-map.md`
3. `context/manifests/project-manifest.yaml`
4. the smallest relevant leaf docs
5. ADRs only when rationale or trade-offs matter

Do not recursively follow every related link or manifest `next_reads` entry. Those links are optional navigation hints.

## Do not vendor by default

Do not copy source-repository machinery into consumers unless there is a specific reason:

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

Those files are for developing and maintaining this repository, not for applying the context framework in another project.

## Suggested consumer layout

```text
consumer-repo/
  AGENTS.md
  docs/
    00-map.md              # recommended if docs/ is already the repo knowledge store
    vendor/
      design-context/
        LICENSE
        README.md
        AGENTS.md
        VENDORING.md
        context/
        docs/
          adr/
```

The consumer repo's own `AGENTS.md` should stay short: treat it as a map, not a handbook.

```md
For reusable architecture/domain-modeling guidance, read:
1. docs/vendor/design-context/README.md
2. docs/vendor/design-context/context/00-map.md
3. docs/vendor/design-context/context/manifests/project-manifest.yaml

Load only the smallest relevant leaf docs for the task.
Do not recursively follow every related link or manifest next_reads entry.
Project-specific docs under docs/ override generic vendored guidance when they conflict.
Do not edit docs/vendor/design-context/ unless explicitly asked to update the vendored pack.
```

If the consumer repo has a `docs/00-map.md`, point to the vendored framework from there too:

```md
## Reusable framework guidance

- `docs/vendor/design-context/README.md`
- `docs/vendor/design-context/context/00-map.md`
- `docs/vendor/design-context/context/manifests/project-manifest.yaml`
```

## Update discipline

- Keep the vendored directory path stable.
- Preserve `LICENSE` with copied content.
- Prefer replacing the vendored pack from a known commit or tag over editing it in place.
- Put consumer-specific adaptations outside the vendored directory.
- Keep project-specific docs local to the consumer repo and let them override generic guidance when needed.
- If a local change should benefit all consumers, upstream it here rather than forking silently.

## Relationship to future exports

A future exporter may generate Claude, Cursor, Copilot, or AGENTS-specific outputs from the canonical docs. Until then, manual vendoring of the core pack is the supported approach.

## Related docs

- `docs/adr/0005-core-context-pack-and-vendoring-boundary.md`
- `docs/adr/0002-lightweight-validation-before-agent-exports.md`
- `context/principles/01-information-architecture-and-manifests.md`
