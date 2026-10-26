# Contributing

This guide is the working contract for people and agents changing Standard.
Start with the [repository map](../explain/repository-map.md) when responsibilities
are unclear; `docs/SUMMARY.md` indexes the book's other topics. Keep documents
in English and reuse the [glossary](../glossary.md),
[conventions](../reference/conventions.md) and accepted
[ADRs](../explain/architecture-decision-records/), rather than restating
them. [ADR 0007](../explain/architecture-decision-records/#7-adopt-design-context-without-vendoring)
explains the adoption policy; the external method is optional for routine work.

## Work contract and authority

Before editing, read applicable instructions, record HEAD and inspect both staged
and unstaged changes plus untracked files. Preserve work already present; a clean
checkout of HEAD alone is not a faithful validation of an uncommitted delivery.

```sh
git rev-parse HEAD
git status --short --branch
git diff --stat
git diff --cached --stat
```

The request or work item should state current behavior, desired outcome, scope,
acceptance evidence, exclusions and who can accept consequential decisions. For
non-trivial work, briefly name affected responsibilities, interfaces and invariants
before implementing. Use the request itself for a small task; do not create a
parallel planning system just to repeat it.

- **Eligible:** scope and acceptance are clear enough to start. Missing semantic
  decisions permit investigation, not an invented implementation.
- **Active:** work on one reviewable slice in the requested mode: explore evidence,
  brainstorm labeled alternatives, support a human decision, or implement an
  accepted decision. Changing mode or scope needs an explicit checkpoint.
- **Blocked:** preserve evidence and explain whether permission, context, a
  conflicting source, a failed check or human judgment is missing. Name the needed
  validator, or say that ownership is unassigned. Retry only with a concrete,
  bounded recovery step; do not loop or silently weaken a gate.
- **Ready for review:** hand off changes, evidence and gaps; this is not merge
  acceptance. **Done** requires acceptance by the responsible reviewer, not an
  agent's self-report or a snapshot match.

Use [open questions](../discovery/open-questions.md) for unresolved meaning and its
knowledge status. Code shows implemented behavior; it does not override an
accepted decision or resolve conflicting documentation. Document approval does
not resolve Q1–Q4. Directory layout alone assigns neither DDD boundaries nor
validation ownership. Keep new functional corrections separate from documentation.

## Permissions and isolation

Reading sources, Git diffs and action bodies is the first step. Discovery,
building and execution are distinct; see the
[registry's effect boundary](../reference/registry.md#discovery-building-and-execution-are-different).
A selector listed by the CLI is not permission to run it. In particular,
`containers.publish` writes to remote registries, `load` writes to local container
stores, profile actions alter profiles, and Terraform actions can alter
infrastructure. Do not run them as validation shortcuts.

- Do not commit, push, open remote PRs, publish, deploy or modify infrastructure
  without an explicit request and appropriate authorization. Never infer approval
  from credentials already present in the environment.
- Do not run `direnv allow`, update locks, synchronize subflakes, accept snapshots
  with `namaka review`, or install hooks as automatic preparation. Dependency
  maintenance has its own [documented procedure][shells]; it is not a prerequisite
  for a documentation change.
- Before a check, inspect its writes, network use and resource needs. Nix evaluation
  can fetch inputs and build through import-from-derivation; a build can fetch
  dependencies and write to the Nix store. Neither is a pure text inspection.
- Use a disposable copy containing the actual patch **and untracked new files** for
  checks that generate files or enter development environments. Keep symlinks
  intact and exclude credentials, existing build output and developer caches.
  Use a separate HOME, XDG cache/config/state directories, temporary directory and
  tool caches; do not inherit another checkout's `PRJ_*` or direnv state.
- Do not share Git hook storage with the working checkout. A linked worktree alone
  does not isolate it. If Git metadata is needed, use an independent disposable
  repository; never point it at the original `.git` directory. Nix store writes
  remain shared, not rolled back with the copy.

The default [development shell][shell-definition] generates Nixago configuration
and installs [Git hooks][hook-definition]. The book shell can update `book.toml`
and `.gitignore`. `treefmt --fail-on-change` still **writes** formatting changes;
Namaka can create pending snapshots. Run these in the disposable workspace and
review any proposed changes instead of copying generated files back wholesale.

## Validation by surface

Choose the smallest checks that cover the change and required gates. Widen when
shared contracts, inputs or consumers change, a relevant result becomes stale, or
impact is unclear. Reuse traceable evidence only while its source, dependencies,
environment and obligations still apply. Stop once coverage is sufficient;
untested and blocked checks are not passes.

| Surface                            | Read and select evidence                                                                                                                                                                                                                                                              |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Documentation/navigation           | Review source claims, relative links, anchors, includes and `docs/SUMMARY.md`; use [documentation checks](#documentation-checks). Render the book when navigation, includes or generation are affected.                                                                               |
| Discovery, Soil, Block Types       | [Core and bootstrap map](../explain/repository-map.md), affected producer/action and fixtures under `tests/core-grow`, `tests/core-soil`, `tests/bt-blocktypes`; use [Nix snapshots](#nix-snapshots). Action snapshots do not prove remote effects or execute generated shell checks. |
| Registry or consumer contract      | [Registry](../reference/registry.md) and [open questions](../discovery/open-questions.md), then affected Go, Rust, direnv and CI boundaries. Choose the corresponding checks below; snapshots alone are not schema validation or a compatibility decision.                            |
| Bootstrap/private inputs/identity  | `flake.nix`, `dogfood.nix`, `tests/dogfood` and `tests/fork-identity`; use the existing snapshot suite, then relevant package/shell checks if behavior changed.                                                                                                                       |
| Go CLI/TUI                         | [CLI README][cli-readme], `src/std/cli/`; use [Go tests](#go-tests). Cache tests are not end-to-end action-execution coverage.                                                                                                                                                        |
| direnv                             | [direnv README][direnv-readme], `src/std/direnv/lib.sh`, `.envrc`; use the [mocked check](#direnv-check), not live approvals.                                                                                                                                                         |
| Rust preprocessor/book integration | [Preprocessor README][preprocessor-readme] and `book.toml`; distinguish the [protocol check](#preprocessor-protocol) from a [full book build](#documentation-checks).                                                                                                                 |

Commands below run from the root of the disposable copy, unless noted. They use
existing surfaces, not new gates. Use Nix with flakes enabled (root minimum 2.13),
and the repository's locked environments. The examples target `x86_64-linux`;
select an appropriate supported system on other hosts. Retain both lock guards:
no update and no write. Nested tools may invoke Nix without those guards; check
the final diff, including lock and snapshot hashes. The linked source wiring was
checked at `322921b`; revalidate it when commands or their inputs change.

### Documentation checks

```sh
git diff --check
git diff --cached --check
```

These do not inspect untracked file contents: review those explicitly too.
For formatting, replace the example filename with the changed-file list. The
default shell supplies the generated treefmt configuration and formatters:

```sh
nix develop --no-update-lock-file --no-write-lock-file -c treefmt --no-cache --fail-on-change docs/guides/contributing.md
```

For the full book, including the real registry-backed Cell chapters:

```sh
nix develop --no-update-lock-file --no-write-lock-file .#book -c mdbook build
```

This evaluates `.#__std.init` via the preprocessor and writes `docs/book`. Inspect
warnings and rendered links; exit zero alone does not establish that every link
works. Do not publish the output as part of validation.

### Nix snapshots

```sh
nix eval --no-update-lock-file --no-write-lock-file --json .#x86_64-linux.tests.checks.snapshots.check
```

[`src/tests/checks.nix`][snapshot-definition] loads the aggregate suite. A successful
result can be `{}` with individual results in the `namaka` trace; do not invent
per-fixture flake attributes or mistake an empty set for no tests. Inspect the
trace and failures. The existing [Namaka configuration][namaka-config] and
[Block Type][namaka-type] connect the CLI to this evaluator; Namaka's wrapper may
write pending snapshots. Snapshot acceptance requires separate semantic review,
not automatic regeneration to make the suite green.

### Go tests

The default shell supplies Go but not a C compiler for CGO. On Linux, add a
compiler temporarily from the same locked nixpkgs, without changing dependencies
or disabling CGO to make the check pass:

```sh
nix develop --no-update-lock-file --no-write-lock-file -c \
  nix shell --no-update-lock-file --no-write-lock-file --inputs-from . nixpkgs#gcc -c \
  bash -c 'cd src/std/cli && go test -mod=readonly ./...'
```

Keep module and build caches in the isolated environment. `-mod=readonly` forbids
implicit `go.mod` updates; fetching dependencies is still possible. Compare both
`go.mod` and `go.sum` afterward rather than assuming the command cannot write.

### direnv check

```sh
nix build --no-update-lock-file --no-write-lock-file --no-link .#checks.x86_64-linux.direnv
```

The [derivation][direnv-check] runs Bash syntax, ShellCheck and mocked behavior
tests. A separate real-direnv experiment needs explicit scope and isolated
approvals/profiles; it is not required for ordinary Markdown changes.

### Preprocessor protocol

```sh
nix build --no-update-lock-file --no-write-lock-file --no-link './src/data#mdbook-paisano-preprocessor.packages.x86_64-linux.default.tests.mdbook'
```

This uses the real mdBook protocol but `multi = []`, so it does not exercise the
real registry reference chapters. It does not resolve the
[licensing question](../discovery/open-questions.md#q3-preprocessor-licensing).

### Existing automation and gates

The [pre-commit hook][hook-config] runs treefmt on staged files; the commit-message
hook runs Conform. [CI][ci-workflow] calls the [reusable workflow][std-workflow]
for Linux and macOS, discovering `checks.check`, `cli.build` and `shells.build`
through external `divnix/std-action`. Its subflake synchronization is not a step
to copy into unrelated local validation. Local checks do not certify remote CI
or branch-protection requirements: retain any required checks as pending until
observed. Do not trigger the Pages or release workflows to validate documentation.

## Handoff and orientation pilots

Deliver one reviewable slice at a time. Report scope, changed files, exact checks
and environment, results/warnings, unexecuted or blocked gates, and open questions
with owners or the ownership gap. Keep agreed conclusions and relevant evidence,
not a transcript. Update an existing work item only when authorized; a local
handoff does not authorize a branch, commit or remote PR. Stop for review before
starting a separately scoped delivery.

Test orientation in a **fresh session** with this repository and its `AGENTS.md`,
without the implementation conversation, its handoff or a personal framework
checkout. Give it one task at a time:

1. Explain how a Target reaches the CLI, citing the producer and consumer.
2. Propose a Block Type change and select validation; do not implement it.
3. Analyze a contract discrepancy without turning a hypothesis into a decision.
4. Identify the effects of `containers.publish` without running it.

Record selected readings, source citations, vocabulary, permission handling and
whether the conclusion is usable. Repeated failures should lead to a specific
navigation/documentation improvement, or a separately approved check, not more
generic warnings. A walkthrough by the author in the existing session is not a
clean-context pilot; if a fresh session is unavailable, mark the pilot pending.

## Methodological reference

The single current reference is public
[design-context at `7f57f677da43a9cd9b5d3d264063b17d931cf150`][method-commit]
(README release label: v0.6.2). Public commit metadata and the consulted raw files
were verified on 2026-10-26. This is a methodological citation, not a flake input,
dependency pin or promise to follow upstream changes.

For methodological work only, start with the pinned [README][method-readme] →
[context map][method-map] → [manifest][method-manifest], then choose a leaf:

- [01 — modeling and knowledge provenance][method-model] for evidence and acceptance.
- [02 — boundaries][method-boundaries] for as-is versus proposed responsibilities.
- [10 — contracts][method-contracts] for producer/consumer meaning and translation.
- [11 — agent-ready work][method-work] for scope, isolation and proportionate checks.
- [06 — operability review][method-review] for evaluating the resulting workflow.

Do not load the whole corpus, copy its pack or adopt its tooling by default.
Standard's accepted decisions prevail; unresolved local meaning stays unresolved.
If the public source is unreachable, ordinary work can still use the local docs;
report a blocked methodological lookup instead of silently switching revisions.

[shells]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/local/shells.md
[shell-definition]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/local/shells.nix
[hook-definition]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/lib/cfg/lefthook.nix
[hook-config]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/configs/lefthook.nix
[cli-readme]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/cli/README.md
[direnv-readme]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/direnv/README.md
[preprocessor-readme]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/data/mdbook-paisano-preprocessor/README.md
[snapshot-definition]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/tests/checks.nix
[namaka-config]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/namaka.toml
[namaka-type]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/std/fwlib/blockTypes/namaka.nix
[direnv-check]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/src/tests/direnv.nix
[ci-workflow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/.github/workflows/ci.yml
[std-workflow]: https://github.com/nadanix/std/blob/322921ba8adda373f1a4bb57b78fc201322c8b93/.github/workflows/std.yml
[method-commit]: https://github.com/oneingan/design-context/commit/7f57f677da43a9cd9b5d3d264063b17d931cf150
[method-readme]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/README.md
[method-map]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/00-map.md
[method-manifest]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/manifests/project-manifest.yaml
[method-model]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/playbooks/01-domain-modeling-playbook.md
[method-boundaries]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/playbooks/02-bounded-context-definition-playbook.md
[method-contracts]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md
[method-work]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/playbooks/11-agent-ready-repository-playbook.md
[method-review]: https://github.com/oneingan/design-context/blob/7f57f677da43a9cd9b5d3d264063b17d931cf150/context/review/06-agent-operability-checklist.md
