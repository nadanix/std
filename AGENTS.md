<!--
SPDX-FileCopyrightText: The Standard Authors
SPDX-License-Identifier: Unlicense
-->

# Working in Standard

Standard organizes Nix code into Cells, Cell Blocks, Targets and discoverable
Actions. Start with the [contribution contract](docs/guides/contributing.md), then
load only the row relevant to the task. Check HEAD, staged/unstaged changes and
untracked files before editing; preserve existing work.

| Task                                           | Read next / code boundary                                                                                                                                                                                     | Validation route                                                                             |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| Understand the model or bootstrap              | [Repository map](docs/explain/repository-map.md), [glossary](docs/glossary.md); `flake.nix`, `dogfood.nix`                                                                                                    | Documentation; bootstrap snapshots if changed                                                |
| Trace a Target to the CLI or change `__std`    | [Registry](docs/reference/registry.md); `src/std/core/grow/newExtractFor.nix`, `src/std/cli/flake/`, `src/std/cli/data/data.go`                                                                               | Affected producer and consumers; do not equate snapshots with schema conformance             |
| Change discovery or Soil                       | [Conventions](docs/reference/conventions.md), relevant [ADR](docs/explain/architecture-decision-records/Readme.md); `src/std/core/`                                                                           | Nix snapshots: `tests/core-grow`, `tests/core-soil`                                          |
| Propose/change a Block Type or inspect effects | [Block Types](docs/reference/blocktypes.md), [registry effects](docs/reference/registry.md#discovery-building-and-execution-are-different); `src/std/fwlib/blockTypes/`, `_mkCommand.nix` in `src/std/fwlib/` | `tests/bt-blocktypes`; inspect the action body, never run publication/deployment as a check  |
| Change the Go CLI or direnv                    | [CLI README](src/std/cli/README.md) or [direnv README](src/std/direnv/README.md)                                                                                                                              | Go tests or mocked direnv check                                                              |
| Change docs or the Rust preprocessor           | [Book index](docs/SUMMARY.md), [preprocessor README](src/data/mdbook-paisano-preprocessor/README.md); `book.toml`                                                                                             | Formatting/links; full book or protocol check as appropriate                                 |
| Investigate conflicting claims                 | [Open questions](docs/discovery/open-questions.md), then the cited sources                                                                                                                                    | Preserve evidence/status; ask the accountable validator, do not choose a contract implicitly |

Exact commands, scope limits and existing gates are in
[validation by surface](docs/guides/contributing.md#validation-by-surface).
Use a disposable copy for shell entry, generated files and mutating checks;
`treefmt --fail-on-change` can write files. Do not update locks, accept snapshots,
run `direnv allow`, commit, push, open remote PRs or perform external actions
without explicit authorization. Registry discovery is not execution permission.

Accepted local decisions prevail over generic advice. Implementation observations
and document approval do not resolve open questions. Keep functional corrections
separate; hand off evidence and gaps, then stop at the requested review boundary.

Use [design-context selectively](docs/guides/contributing.md#methodological-reference)
only when methodological guidance is needed. Its public commit pin lives there;
no personal checkout, vendored pack, additional manifest or agent infrastructure
is required. Do not load the full framework or the entire book by default.
