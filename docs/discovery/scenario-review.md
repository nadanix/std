# Scenario review

## Status and scope

**Discovery is closed for these nine scenarios; the model is not declared
validated.** On 2026-10-26, the requesting user, acting as reviewer of the discovery
delivery, accepted blocks F1–F4 (records R1–R4) and the final synthesis F5 (R5).
At discovery closure, R5 explicitly retained Q1/Q2/Q4, P-F1–P-F4, the B3 operational
gap and all mechanical limits, including F4's then-unexecuted jq filters. This is
acceptance of a bounded discovery delivery, not representation of external
consumers or approval of new contracts. Documentary promotion was authorized separately. A separately
authorized data-only follow-up on 2026-10-27 completed the jq checks described in
C2/C3 below; it does not rewrite the original failed run or resolve contracts.
The subsequent local `ci.meta` shape decision and schema correction are recorded
separately in [Q1](open-questions.md#q1-ci-metadata-shape); the historical results
below remain unchanged.

On 2026-10-27, the requesting user also accepted the
[Q4/P-F4 reframing](open-questions.md#q4-registry-evolution-and-compatibility):
Q4 is a future registry-format versioning consideration, not a merge prerequisite
for PR #1; P-F4 is retired as a registry-contract question. C3 remains evidence
of project-reference changes, not a schema-versioning problem. This changes the
interpretation and question status, not the probe results or Q1's accepted shape
decision. No new probe or consumer validation is claimed.

Later on the same date, the requesting user separately accepted and authorized
[Q2's function-only Block contract](open-questions.md#q2-cell-block-functions-and-attribute-sets),
including immediate attrset rejection and migration of this repository. The
historical A1/A2 results below are preserved, not rerun or relabeled as evidence
for that new behavior. The implementation has its own regression check.

The requesting user subsequently accepted [P-F3's argument-handling contract](open-questions.md#p-f3-argument-handling-in-tui-and-direct-cli)
on 2026-10-27: the TUI directs users to CLI for Actions declared as requiring
arguments; CLI delegates validation to the Action/tool. This resolves P-F3 for
the fork without changing implementation. B2 retains the original source-only
record and distinguishes the later bounded CLI/TUI probes below.

This review uses the [glossary](../glossary.md),
[registry reference](../reference/registry.md) and accepted
[calling-interface][adr-interface] and [system-first][adr-system] decisions.
It does not replace them. Remaining questions are listed in
[Open questions](open-questions.md); their validation owners are unassigned. A Cell is not, by its directory alone, a DDD
bounded context or an organizational ownership assignment.

### Provenance and reading the evidence

- Local implementation baseline: [`d0f1c75`][baseline] of `nadanix/std`.
  Source links below are pinned evidence, not navigation to a future `main`.
- External integration examined: `divnix/std-action` at
  [`4d88d45`][external]. The workflow's `@main` does not identify which revision
  a historical or future job uses. No remote CI result is established here.
- Historical investigation: 2026-10-26, `x86_64-linux`, Lix 2.96.0; tools from
  nixpkgs [`01a4873`][nixpkgs]. Each probe used a disposable copy of the baseline,
  separate HOME/XDG/TMP directories, a clean process environment and no lock
  updates. The Nix store, daemon and system configuration remained shared.
- Data-only follow-up: 2026-10-27, using the retained F4 JSON and the same pinned
  source bytes, verified against their original hashes. Nix resolved cached tools
  offline; Python/jq ran in a separate network namespace with read-only inputs
  and fresh outputs. No new Standard evaluation/build or remote source lookup.
- `observed` distinguishes source reading from probe execution; `inferred`
  marks consequences not exercised. At discovery closure, Q1/Q2 were `disputed`
  public contracts; Q4 and the P-F questions were `unknown` commitments. No contract is promoted
  to `confirmed` by a passing assertion or by approval of this document.
- The conditions and decisive results below are a curated historical evidence
  record. Disposable checkouts, caches, full logs and probe scripts are not
  vendored. This is not a complete reproduction archive or a new test suite;
  source citations establish implementation provenance, not a rerun of a probe.
  A fresh execution claim would need separately scoped checks and their outputs.

## Nine scenarios

### A1. From a Block function to a Target

**Prediction:** in the single-layer example, the imported function receives the
prepared signature; its string Target becomes an ordinary output and is projected
into `init`, `actions` and `ci`. A Target need not be a derivation or executable.

The F1 probe reduced [`tests/core-grow`][grow-test] to one system, Cell, Block,
Target and Action. It supplied `self.sourceInfo.outPath = "constant-self"`, with
revision `constant-rev`, used Target `self = "via foo-cell ${inputs.self}"` and
enabled `ci.foo-action = true` only in the probe.
At the reviewed revision, [`grow/default.nix`][grow] used `scopedImport`, called
function Blocks and checked the returned Target set;
[`newExtractFor.nix`][extract] separately extracted metadata, commands and CI
candidates.

**Observed by evaluation/assertions (`passed`):**

```text
Target: x86_64-linux.foo-cell.test-block.self = "via foo-cell constant-self"
init: one foo-action, requiresArgs = false
ci: one candidate, targetDrv = null, meta = null, proviso = null
Action derivation: yky0559igq0pa2f9b1zamssjzfq88fiz-foo-action.drv
Action output:    5jb1c9w9bj7dxxhhsx5ihciliq557rpb-foo-action
```

The last two identifiers are Nix store basenames, not stable public names. The
name tuple joins projections in this example; it does not establish uniqueness
under composition, exhaustive Target typing or cross-system behavior.

### A2. Function versus attribute-set import

**Prediction:** the same Block body, imported as an attrset instead of a function,
can access the signature through `scopedImport` and produce the same result in
this example. At the reviewed revision, [`types/default.nix`][types] accepted
both forms; [the importer][grow] called functions but returned imported sets
directly.

**Observed by F2 evaluation/assertions (`passed`):** with the same F1 inputs and
body, the two forms produced equal Target values, serialized registries and
Action derivation paths. No Action was built or executed in F2.

This is not proof of equivalence for arbitrary imports or support for attrsets
as a public alternative. At discovery closure,
[Q2](open-questions.md#q2-cell-block-functions-and-attribute-sets) remained disputed
against Conventions and ADR 0002. The later, separately accepted function-only
decision resolves Q2 for this fork without changing this historical result or
retaining attrset compatibility.

### A3. Two Soil layers with the same identity

**Prediction:** the tested composition selects one ordinary output/Action while
retaining both layers' announcements and CI candidates. [`grow-on.nix`][grow-on]
merges attributes recursively and treats `__std.init`/`ci` lists separately.

F2 used an empty base and layers A and B with the same
`//foo-cell/test-block/self:foo-action` identity but different Target strings and
`echo` command derivations. **Observed by evaluation/assertions (`passed`):**

| Composition | Selected ordinary Target / Action | `init` announcements | `ci` candidates                   |
| ----------- | --------------------------------- | -------------------- | --------------------------------- |
| A then B    | A                                 | A, B; same selector  | A, B; distinct Action derivations |
| B then A    | B                                 | B, A; same selector  | B, A; distinct Action derivations |

The selected derivations were `8z5k27065b41dg9zqmm4lqqz1z1naq0w-foo-action.drv`
for A and `37k87m2bqlwpljfrz8va70wwnb05vrdk-foo-action.drv` for B. Neither was
built or executed. Go's [name-based selectors][go-data] carry no layer identity:
the consequence that both announcements select the same winning path is
`inferred`, not a TUI execution result. Determinism does not settle P-F2's
coherence requirement or authorize a merge-policy change.

### B1. Selector, built artifact and process

**Prediction:** finding an Action path, building its executable and running it
are distinct stages. [The Go runner][go-run] assembles the selector, builds the
Action, creates a state link and then executes it with the project environment.
Those Go steps were read, not exercised by F1.

**Observed in F1 (`passed`):** the Action from A1 was built with `--no-link` and
its script was read before direct execution. It only printed
`I'm Paisano and 42!`; exit status was 0 and stderr empty. No Go CLI/TUI,
`last-action` link or project environment setup was exercised.

The fixture uses `writeShellScript` directly. The syntax/ShellCheck and
`PRJ_ROOT` guards in [`_mkCommand.nix`][mkcommand] apply to its users, not every
Action. A successful `echo` says nothing about another Action's effects or
recovery, and a CI candidate is not a receipt for a completed job.

### B2. Required arguments in TUI and direct CLI

**Prediction, conditional on successful assembly:** a TUI-selected Action with
`requiresArgs = true` and no extra arguments reaches rejection before the Action
build; direct CLI leaves the flag unset and that guard does not reject it.

**Source observations:** [the extractor][extract] derives the flag from
`target.meta.requiresArgs`; [TUI][go-tui] passes the pointer to `RunActionCmd`,
and [main][go-main] calls `Exec(nil)`. [Direct CLI][go-cli] omits the field and
passes `args[1:]`. [The runner][go-run] checks:

```go
c.RequiresArgs != nil && *c.RequiresArgs == true && len(extraArgs) == 0
```

Assembly happens before this guard and can already invoke Nix to obtain the
system. The consequences above are `inferred`; Go/CLI/TUI execution was
`not-run`. This is neither universal rejection nor validation of argument
meaning. At discovery closure, P-F3 asked whether both entry paths should
guarantee rejection; no code or intended contract was changed in that investigation.
The later [accepted decision](open-questions.md#p-f3-argument-handling-in-tui-and-direct-cli)
retains distinct responsibilities rather than requiring identical rejection.

#### B2 follow-up: CLI/TUI probes

On 2026-10-27, a separately scoped investigation used a disposable copy of
[`87064ed`][b2-follow-up-baseline]; the relevant extractor and CLI/TUI sources
were unchanged from the original discovery baseline. Go 1.26.10, Python 3.14.8
and bubblewrap 0.12.0 came from the locked nixpkgs. Preparation isolated
HOME/XDG/tmp and Go caches, allowed module downloads, disabled remote Nix
builders and retained both lock guards. No production source, lock or Go module
file changed; temporary probes were not added to the repository's test suite.

Six Go subcases passed: TUI selection preserves true/false flags and quits;
the runner's argument guard rejects only true plus an empty argument list among
the tested true/false/unset cases. A binary built from unchanged production
sources then exercised five entry-point cases with synthetic metadata, mock Nix
and an inert Action. Runtime probes used a separate network namespace, no Nix
daemon socket, read-only store/source mounts and private writable case directories.
Mock Nix never delegated to real Nix; its build branch only linked the inert Action.

**Observed in the completed follow-up (`passed`):**

- Direct CLI forwarded no arguments, preserved the inert Action's stdout and
  stderr/help, and exited with its injected status 23. A space-containing
  argument and `-- --help` were forwarded correctly in separate cases (exit 0).
- With `requiresArgs = true`, TUI restored the terminal, then reported
  `run from command line` and exited 1, without a mock build or Action invocation.
- With `requiresArgs = false`, TUI restored the terminal, then the inert Action's
  stdout and stderr/help appeared; its injected exit 23 was preserved.

An initial temporary-flake source-selection error was corrected before compiling.
The first runtime attempt passed the three CLI cases but timed out in TUI startup:
the bare pseudo-terminal did not answer color/cursor queries. Adding those replies
to the harness made all five fresh cases pass, without changing production code
or weakening assertions. The timeout remains a failed harness attempt, not a
successful original run or an established Standard defect.

These are new consumer-execution observations, not a retroactive execution of B2
in F3. They show terminal output after leaving TUI, not an integrated argument
editor or output viewer. They do not evaluate the real producer, build or run
project Actions, establish behavior for every terminal/tool, or accept a contract;
P-F3 was resolved separately by the user's explicit decision.

### B3. Partial publication and unknown remote outcomes

**Prediction:** a sequential publication can leave earlier work after a later
failure. [`containers.nix`][containers] copies tags in order, using the previous
tag as the next source; the inspected body provides no transaction or rollback.

F3 extracted that loop and the strict wrapper prefix, replaced `skopeo` with a
Bash function and used synthetic tags at `scenario.invalid/example`. The function
only recorded calls and wrote local marks; no real executable was delegated to.
A verified separate network namespace, read-only store and private writable
case directory bounded the mock. **Observed results:**

| Mock case                          | Process exit | Calls | Local marks | Assertions |
| ---------------------------------- | ------------ | ----- | ----------- | ---------- |
| All simulated copies succeed       | 0            | 3     | 3           | `passed`   |
| Fail before second simulated write | 42           | 2     | 1           | `passed`   |

The second case never calls tag three and retains the first mark; 42 is the
expected injected error. It does not test real signals, skopeo, remote durability,
atomicity or idempotence. A dispatched real copy without confirmation has an
**unknown remote result**, not necessarily the mock's known pre-write failure.

[The proviso][proviso] inspects one image; it is not per-tag reconciliation or a
recovery protocol. It was not executed. The operational gap remains: identify
who may assess destination evidence and authorize recovery before any real
retry. No incident, retry permission or recovery design is implied here.

### C1. Different consumers, different projections

**Prediction:** announcing a Target does not ensure that all consumers can
document, select or execute it. The [consumer matrix](../reference/registry.md#consumers-and-translations)
distinguishes Go's `init` decoding/name-based action selection, Rust's configured
Cell/readme rendering, direnv's `enter` path/profile handling and external CI's
candidate translation. These paths were examined statically, not run end-to-end.

One F1 fragment was executed with jq 1.8.2, using the A1 candidate and the pinned
external [`discover/eval.sh`][external-discover] selection expression:

```text
action = foo-action
selection expression = .foo-action[] | @base64
jq exit = 3
error = action/0 is not defined
```

**The fragment `failed`.** It was not a complete `std-action` execution or a
remote job; Bash process-substitution propagation was not tested. P-F1 asks
whether that Action name should be admissible in CI discovery at this boundary.
The result neither defines a new naming restriction nor proves a fork CI failure.

### C2. CI metadata, schema and consumer expectations

**Prediction:** `publish` supplies an object `meta.image`, core preserves it,
and the resulting record conflicts with the schema's string/null restriction.
The proviso expects `.meta.image`; its extracted jq expression, not the proviso
process, was exercised in the data-only follow-up below.

F4 evaluated the real `containers` Block Type against a synthetic, non-OCI Target
and inert dependency; no Action or proviso was built or run. Python jsonschema
4.26.0 checked Draft 2020-12 and reported exactly this instance error:

```text
instance path: ci.x86_64-linux[0].meta
instance: {"image": "example.invalid/f4/image:tag"}
allowed types: string, null
```

**C2 conformance `failed` as expected.** In-memory null/string controls conformed;
that does not select either as an operational solution. Source evidence:
[producer][containers], [extraction][extract], [schema][schema] and
[proviso][proviso]. [Q1](open-questions.md#q1-ci-metadata-shape) records the later
local shape decision and the remaining compatibility review; it does not change
this historical schema result.

**Original F4 run, 2026-10-26:** the global verifier failed while extracting jq
filters with a regex that matched `json=(` rather than `json=$(`. Its exit was
**1 (`failed`)**; the jq filters were **`not-run` in that run**. This was a probe
error, not a `std-action` failure. That script, log and failed outcome are retained.

**Data-only follow-up, 2026-10-27:** a copied verifier changed only the extraction
regex from `json=\(` to `json=\$\(`. No assertion was removed or weakened. It
reread the preserved `eval.json`, rechecked the data/schema assertions and ran
jq 1.8.2 on extracted expressions, without sourcing external scripts. Python
3.14.8/jsonschema 4.26.0 were unchanged; bubblewrap 0.12.0 isolated the execution.
The copied verifier completed with **exit 0 (`passed`)**, including the expected
negative string control. This is a new check, not a successful rerun of the Nix
producer or retroactive success for the original F4 command.

Retained input JSON SHA-256:

```text
5cbc8108fa7b385a5a2bfad9afcf194af2a167cf7ac77947e2ac925d157dc525
```

Observed output of the proviso's extracted `@sh "image=\(.meta.image)"` expression:

| Candidate `meta`                                     | jq exit | Output / error                              |
| ---------------------------------------------------- | ------- | ------------------------------------------- |
| Object with `image = "example.invalid/f4/image:tag"` | 0       | `image='example.invalid/f4/image:tag'`      |
| String `"example.invalid/f4/image:tag"`              | 5       | `Cannot index string with string ("image")` |
| `null`                                               | 0       | `image=null`                                |

The outputs are **strings, not executed shell assignments**. Null's exit 0 does
not establish a usable image or a correct proviso decision. Conversely, the
schema-admissible string fails this consumer expression. These observations
sharpen Q1; they do not choose a replacement contract or a fix.

The five extracted programs cover grouping by Action, `jobName`, grouping by
Block/Action, image parsing and runner-field rendering. The follow-up also
checked base64 candidate round-trips and preservation of `meta` for C2 and both
C3 records. For C2 it produced `publish //demo/images/default` under
`images.publish` and rendered the runner fields as strings. **Only these data
projections are now observed.** Provisos, the real discovery/run workflow and
remote CI remain unexecuted; no successful discovery hit or publication is
claimed. The tested Action names were `publish`, `build` and `enter`, not C1's
`foo-action`; P-F1 and its separate failed fragment are unchanged.

### C3. Same derivable Target, different name

**Prediction:** unchanged Target derivation identity does not preserve selectors,
profile paths or companion readme associations after a rename.

F4 evaluated identical `mkShellNoCC` bodies under `old` and `new`, keeping
`old.md` in both variants and providing no `new.md`. The real
[`devshells`][devshells] Action incorporates `fragmentRelPath`; [readme lookup][paths]
is name-based. **Assertions completed before the later F4 verifier failure:**

| Property                                     | Observed comparison               |
| -------------------------------------------- | --------------------------------- |
| Target derivation/output and `build` command | Equal                             |
| Old Target/Action key after rename           | Absent                            |
| `enter` command                              | Different, through `profile_path` |
| `old.md` association                         | Present for old; absent for new   |
| Both full registries against schema v0       | Conformant                        |

The data-only follow-up also observed `build //demo/shells/old` and
`enter //demo/shells/old` becoming their `new` counterparts in `jobName`, with
runner fields rendering `target='old'` versus `target='new'`. These strings were
not executed; no proviso filtered the candidates. Go/Rust/direnv and end-to-end
CI impacts remain `inferred`, not executions of the renamed scenario.

These are changes to project data, references and name-derived artifacts, not to
the registry format. Both registries conform to the same `v0` structure. Losing
the old selector can require project users to update their references, but does
not by itself violate `v0` or require a new schema version.

The original P-F4 question treated this rename as a case of Q4. That conflation
was retired by the later user-accepted
[reframing](open-questions.md#q4-registry-evolution-and-compatibility). Q4 now
concerns possible future registry-format versioning, independently of C3. These
observations establish no obligation to implement aliases or a migration policy.

## Open decisions and accountable perspectives

The questions originated in discovery, when the original Q4/P-F4/C3 grouping
was also open. The table now lists only unresolved follow-up: Q1's local shape
decision is accepted, while its external compatibility review remains open;
Q2 and P-F3 are resolved for the fork by the later explicit decisions, Q4 is a
future design consideration and P-F4 is retired. See
[Open questions](open-questions.md) for the current statuses and accepted
reframing. The roles below are needed perspectives, not assigned people, a
validated contract or an authorized implementation backlog.

| Question           | Decision and impact                                                                      | Needed perspectives / next human step                                                                                                          |
| ------------------ | ---------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| P-F2 / A3          | Must every announcement/candidate identify its own selectable command under a collision? | Core/Soil maintainers, Cell authors and CLI/CI consumers: decide coherence requirements for A→B                                                |
| B3 operational gap | Who assesses per-tag evidence and authorizes recovery after partial/unknown effects?     | Authorized publication/destination operator and integration maintainers: establish ownership and authority for an actual case before retrying  |
| P-F1 / C1          | Is `foo-action` admissible when `ci.foo-action` is enabled?                              | Framework/external CI maintainers and Block author: answer for this name and integration revision                                              |
| Q1 / C2            | Remaining external compatibility review of the accepted `ci.meta` shape                  | Framework/schema/container maintainers and CI consumers: assess migration and compatibility impact, without reopening the local shape decision |

Q3 remains open but outside the nine scenarios. Building documentation does not
resolve [preprocessor licensing](open-questions.md#q3-preprocessor-licensing).
No tenth scenario or implicit F6 is introduced.

## Mechanical evidence and remaining limits

This table records the historical discovery runs and separately scoped
follow-ups, **not the checks performed when editing or rendering this page**.
Documentation checks have their own
[validation route](../guides/contributing.md#documentation-checks).

| Block / evidence stage        | Executed evidence                                                                                         | Limits retained                                                                                                       |
| ----------------------------- | --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| F1: A1/B1/C1, accepted in R1  | Evaluation/assertions, build and direct echo `passed`; jq selection fragment `failed` (3)                 | No JSON Schema validation; no Go/Rust/direnv/full CI execution                                                        |
| F2: A2/A3, accepted in R2     | Evaluations and equality/collision assertions `passed`                                                    | No build/Action execution, consumer execution or schema validation                                                    |
| F3: B2/B3, accepted in R3     | Mock control/failure, syntax and network-namespace assertions `passed`                                    | B2 static; no real publication, signal test or recovery validation                                                    |
| F4: C2/C3, accepted in R4     | Final eval completed; C2 rejected, controls/C3 conformant; assertions completed before later failure      | Global verifier `failed` (1); jq filters `not-run`; consumer by reading only                                          |
| F5: synthesis, accepted in R5 | Traceability, note/link and integrity review                                                              | No new model execution or changed status for any earlier check                                                        |
| F4-jq follow-up, 2026-10-27   | Copied data verifier `passed` (0); jq projections observed; string image control `failed` (5) as expected | Original F4 remains `failed` with jq `not-run` in that run; no new Nix evaluation, proviso or end-to-end CI execution |
| B2 follow-up, 2026-10-27      | Six Go subcases and five CLI/TUI entry-point cases `passed` after harness correction                      | Mock Nix and inert Action only; initial TUI timeout retained; original F3/B2 remains source-only                      |

F4 also retained two earlier preparation failures: an import outside the copied
Cell root, then a capture assertion affected by attrset-to-string JSON coercion.
Bounded recovery reached the final evaluation described above; the subsequent
regex failure ended that investigation. Its later repair and new output are
recorded separately. Partial assertions never made the original run pass.

The discovery did not run the repository's aggregate Nix/Go/direnv suites,
preprocessor protocol/full-book checks, remote CI or an independent orientation
pilot. A later book build cannot retroactively exercise the nine probes or
validate their contracts. No publication, load, profile modification, deployment
or remote recovery was performed as discovery validation.

Beyond the observed data projections and bounded B2 consumer probes, stronger
execution claims still require explicitly scoped checks; discovery approval
does not waive them. To validate a contract, obtain acceptance from its
accountable perspectives; another schema
check or mock cannot replace that judgment. Revisit only affected evidence when
its source, inputs, consumer revision or asserted scope changes.

[baseline]: https://github.com/nadanix/std/tree/d0f1c75a672231411e2da3bb6d38374938253d7e
[b2-follow-up-baseline]: https://github.com/nadanix/std/tree/87064eda81acf5af13c1de801a063d6727309c48
[nixpkgs]: https://github.com/NixOS/nixpkgs/tree/01a4873dfe535c3f9190eaabe187d57b81035042
[external]: https://github.com/divnix/std-action/tree/4d88d45cacadad99e60218b4ed83037a5884a33c
[external-discover]: https://github.com/divnix/std-action/blob/4d88d45cacadad99e60218b4ed83037a5884a33c/discover/eval.sh#L43-L57
[adr-interface]: ../explain/architecture-decision-records/#2-restrict-the-calling-interface
[adr-system]: ../explain/architecture-decision-records/#4-early-select-system-for-conceptual-untangling
[grow-test]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/tests/core-grow/expr.nix
[grow]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/grow/default.nix#L91-L167
[extract]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/grow/newExtractFor.nix
[types]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/types/default.nix#L10-L47
[grow-on]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/grow/grow-on.nix#L61-L91
[go-data]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/cli/data/data.go#L59-L89
[go-run]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/cli/flake/run.go#L14-L132
[go-tui]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/cli/tui.go#L290-L305
[go-main]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/cli/main.go#L17-L35
[go-cli]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/cli/cli.go#L21-L69
[mkcommand]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/fwlib/_mkCommand.nix#L9-L41
[containers]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/fwlib/blockTypes/containers.nix#L22-L71
[proviso]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/fwlib/blockTypes/containers-proviso.sh
[schema]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/registry.schema.json#L129-L190
[devshells]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/fwlib/blockTypes/devshells.nix#L20-L57
[paths]: https://github.com/nadanix/std/blob/d0f1c75a672231411e2da3bb6d38374938253d7e/src/std/core/paths.nix#L17-L23
