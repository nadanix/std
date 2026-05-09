# Information Architecture and Manifest Conventions

## Summary

- Design the repository as a retrieval system, not a single handbook.
- Each layer must have a clear responsibility and a different abstraction level.
- Every major area needs a small map and, when stable enough, a manifest.
- Documents should be independently readable and small enough to load selectively.
- Adding, removing, or renaming content is not complete until navigation and manifests are updated.

## Load this when

- defining or changing repository structure
- adding a new context area
- deciding where a new document belongs
- designing retrieval conventions for agents

## Layer responsibilities

| Layer | Purpose | Typical contents | Must not become |
|---|---|---|---|
| Root docs | explain repo purpose and operating model | `README.md`, `AGENTS.md`, `VENDORING.md` | a complete handbook |
| Maps | tell the reader what exists and what to read next | `00-map.md`, area maps | full rule books |
| Principles | state stable, canonical rules | non-negotiables, definitions, constraints | task checklists or long tutorials |
| Patterns | capture reusable solution shapes | alternatives, trade-offs, recurring structures | generic principles repeated verbatim |
| Playbooks | guide task execution | ordered steps, output shapes, checklists | deep theory |
| Glossary | stabilize vocabulary | term definitions, aliases, anti-terms | random notes |
| Review | evaluate quality | quality gates, review questions, rubrics | implementation tutorials |
| Manifests | support retrieval and automation | machine-readable summaries | prose-heavy rationale |
| ADRs | preserve important decisions | trade-offs, alternatives, consequences | day-to-day status notes |

## Standard load order

1. root overview
   - `README.md`
2. nearest navigation file
   - usually `context/00-map.md` or an area `00-map.md`
3. nearest manifest
   - usually `context/manifests/project-manifest.yaml`
4. smallest relevant leaf docs
5. ADRs if trade-offs matter

## Directory contract

Every major directory should eventually provide:

1. a small entry document
2. a machine-readable manifest or an entry in a parent manifest
3. leaf docs with stable names
4. a low-duplication relationship to nearby directories

If any of these is missing, the area is harder for agents to use under tight context budgets.

## Document contract

A canonical leaf document should usually contain:

1. title
2. summary bullets
3. when to load it
4. scope or rules
5. related documents
6. review questions or failure modes

## Size budgets

Use these as soft limits unless there is a strong reason not to.

| Artifact type | Budget |
|---|---|
| root docs | under 200 lines |
| map docs | under 150 lines |
| leaf principle docs | about 80 to 220 lines |
| playbooks/checklists | short enough to execute in one pass |

When a file grows beyond its budget, prefer splitting by task or abstraction level rather than appending more sections.

## Naming conventions for structure

- maps use `00-map.md` or a local `README.md`
- principle docs use numbered, descriptive names
- manifests end in `-manifest.yaml`
- ADRs use zero-padded numeric prefixes
- names should describe the artifact's purpose and load condition

Favor names that answer both:
- what is this artifact?
- when should an agent load it?

## Manifest conventions

Use YAML for manifests. Prefer simple, explicit keys.

### Recommended shape

```yaml
manifest_version: 1
area: principles
map: context/principles/00-map.md
entries:
  - path: context/principles/01-information-architecture-and-manifests.md
    title: Information Architecture and Manifest Conventions
    canonical: true
    summary: Defines layer responsibilities, load order, and manifest rules.
    load_when:
      - shaping repository structure
      - deciding where a new document belongs
    tags:
      - information-architecture
      - retrieval
    next_reads:
      - context/principles/06-deep-modules-and-information-hiding.md
```

### Preferred keys

- `manifest_version`
- `area`
- `map`
- `entries`

Per entry, prefer:

- `path`
- `title`
- `canonical`
- `summary`
- `load_when`
- `tags`
- `next_reads`
- `status`

Use extra keys only when they improve retrieval or tooling.

## Manifest update rules

When adding, removing, or renaming a canonical document:

1. update the nearest map
2. update the nearest manifest
3. update parent manifests if discovery would otherwise break
4. update related ADR or README references if they mention the artifact

A new file that is not discoverable through maps or manifests is incomplete.

## Abstraction rules

Different layers must not collapse into one another.

- maps answer **what exists and what next**
- principles answer **what is true or required**
- patterns answer **what shape tends to work**
- playbooks answer **what to do now**
- review docs answer **whether it is good enough**
- ADRs answer **why this decision was made**

If a file tries to answer all of these questions, split it.

## Review questions

- Can a new agent find the right next file in under two hops?
- Does each major area expose a small surface and hide detail beneath it?
- Are manifests concise and machine-friendly?
- Does each file stay at one abstraction level?
- Are maps and manifests aligned with the current file set?

## Related docs

- `context/00-map.md`
- `context/principles/00-map.md`
- `context/principles/06-deep-modules-and-information-hiding.md`
- `context/manifests/project-manifest.yaml`
- `context/manifests/principles-manifest.yaml`
- `VENDORING.md`
