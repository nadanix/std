# 7. Adopt design-context without vendoring

Date: 2026-10-26

## Status

accepted — documentation and working-method adoption only

## Context

Standard needs discoverable, repository-owned knowledge so people and agents can
reason about its model, implementation boundaries, contracts and validation.
Existing architecture, vocabulary, conventions and ADRs already carry decisions;
the [repository map](../repository-map.md) and
[registry reference](../../reference/registry.md) describe the implementation.
They should be connected, not replaced by another documentation hierarchy.

The public `design-context` framework offers useful guidance on knowledge
provenance, selective context loading and proportionate verification. Its default
vendoring layout and source-repository tooling are not prerequisites for using
those methods in Standard.

## Decision

- Adopt the method **without vendoring** the framework or adding an agent runner,
  provider configuration, framework tooling or other agent infrastructure.
- Keep the current public, immutable commit reference in one place:
  [Contributing — Methodological reference](../../guides/contributing.md#methodological-reference).
  Updating it is an explicit documentation review, not following a moving branch
  or changing a flake dependency.
- Make ordinary work possible with Standard's own documentation. Use a brief root
  `AGENTS.md` for task routing, the existing `docs/SUMMARY.md` for book navigation,
  and the [contribution guide](../../guides/contributing.md) for the work contract.
  Do not add another map or manifest without a demonstrated navigation need.
- Accepted Standard-specific decisions take precedence over generic framework
  recommendations. Implementation evidence is not automatically accepted design;
  contradictions must remain explicit until an accountable validator resolves
  them. A Cell directory is not automatically a DDD bounded context.
- Verify the affected surface with the narrowest sufficient checks and all gates
  required for the handoff. Report blocked or unexecuted checks, isolate checks
  with side effects, and do not infer semantic acceptance from passing snapshots.

This decision accepts the adoption approach, **not answers to the
[open questions](../../discovery/open-questions.md)**. It does not change runtime
behavior, registry schemas, compatibility guarantees, dependencies or snapshots.

## Consequences

Local knowledge and navigation remain small and useful without access to the
external framework. Methodological lookups need public network access, but a
pinned revision makes their source auditable. Maintainers must deliberately review
reference updates and keep task routes aligned with the implementation.

The project does not inherit the framework's manifests, checks or autonomy model.
Missing contract decisions still need accountable human acceptance; new checks or
functional corrections require a separately scoped change. Revisit vendoring or
additional navigation only if observed work repeatedly demonstrates a concrete
need, rather than installing infrastructure in anticipation of one.
