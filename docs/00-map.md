# std Knowledge Map

This is the repository-local entrypoint for agent-facing architecture knowledge.
It complements the historical root `ARCHITECTURE.md` by exposing smaller,
retrievable docs that agents can load progressively.

## Start here

1. `docs/architecture/00-map.md`
2. `docs/architecture/std-domain-model.md`
3. `docs/architecture/dependency-contracts.md`
4. `docs/agent/validation-harness.md`

## Reusable modeling guidance

The generic modeling framework is vendored at:

- `docs/vendor/design-context/README.md`
- `docs/vendor/design-context/context/00-map.md`
- `docs/vendor/design-context/context/manifests/project-manifest.yaml`

Use those docs for patterns, playbooks, and review checklists. Use this `docs/`
tree for `std`-specific architecture decisions, contracts, workflows, and
validation rules.

## Areas

| Area                 | Purpose                                                                         |
| -------------------- | ------------------------------------------------------------------------------- |
| `docs/architecture/` | Bounded contexts, domain model, contracts, workflows, and invariants for `std`. |
| `docs/agent/`        | Agent harness, validation loop, doc-gardening, and review philosophy.           |
| `docs/manifests/`    | Machine-readable retrieval metadata for the new architecture docs.              |
| `docs/plans/`        | Versioned execution plans and technical debt notes.                             |
| `docs/generated/`    | Generated or generator-owned snapshots that help agents inspect the repo.       |

## Harness-engineering stance

This repo treats `AGENTS.md` as a table of contents, not as a handbook. Durable
knowledge should live in versioned docs, manifests, schemas, tests, or scripts.
When guidance becomes important enough to block drift, promote it into a
mechanical check.
