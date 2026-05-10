# std Workflows

## Summary

- Model `std` behavior as explicit workflows rather than hidden Nix magic.
- Separate pure decisions from edge effects such as shell execution, package
  building, deployment tools, or generated files.
- Long-running or optional behavior should expose stable states and failures.

## Workflow: grow project

| Field   | Description                                                               |
| ------- | ------------------------------------------------------------------------- |
| Purpose | Import a repo into the std artifact model.                                |
| Trigger | Flake evaluation calls `std.grow` or `std.growOn`.                        |
| Input   | `inputs`, `systems`, `cellsFrom`, `cellBlocks`, optional `nixpkgsConfig`. |
| Output  | std-shaped graph, registry metadata, optional compatibility soil.         |

Steps:

1. Filter the source tree before import when needed, preferably through native `lib.fileset` helpers (`std.fileset.include` in this repo).
2. Pass `std.grow` / `std.growOn` configuration to Paisano's config processor.
3. Normalize systems, deduplicate declared Cell Blocks, and discover Cells under
   `cellsFrom`.
4. For each system, build the import signature: de-systemize inputs,
   instantiate `nixpkgs`, inject `inputs.cells`, and expose source metadata.
5. Discover declared Cell Blocks through Paisano path conventions:
   `<cell>/<block>.nix` or `<cell>/<block>/default.nix`.
6. Load each discovered Cell Block with the `{ inputs, cell }` signature.
7. Apply the Cell Block's Block Type and target extractor to materialize actions
   and registry metadata.
8. Accumulate the std output graph and registry lanes: `__std.actions`,
   `__std.init`, and `__std.ci`.
9. If using `std.growOn`, merge additional flake-output soil around the graph;
   if using `std.grow`, return the graph without the soil functor surface.

Invariants:

- Cell Blocks use the `{ inputs, cell }` interface.
- Block Type declarations define which blocks are import candidates.
- Missing declared blocks are skipped; undeclared blocks are not part of the
  model.
- The absorbed Paisano core owns config normalization, path discovery, import
  signatures, target extraction, and registry lane construction.
- The public output must remain discoverable through the registry.

## Workflow: harvest outputs

| Field   | Description                                                              |
| ------- | ------------------------------------------------------------------------ |
| Purpose | Translate std-shaped outputs into Nix CLI-compatible flake outputs.      |
| Trigger | A flake calls `std.harvest`, `std.pick`, or `std.winnow`.                |
| Input   | std graph and one or more harvester paths.                               |
| Output  | Flake outputs such as `packages`, `devShells`, `checks`, or `templates`. |

Steps:

1. Choose target paths in the std graph.
2. Apply the absorbed Paisano soil translator (`harvest`, `pick`, or `winnow`).
3. Preserve or remove system scope according to the target function.
4. Publish the translated output under the expected flake key.

Failure modes:

- Missing or mistyped path.
- Lossy translation when the target flake schema is less expressive than the std
  graph.

## Workflow: invoke action

| Field   | Description                                                  |
| ------- | ------------------------------------------------------------ |
| Purpose | Run an action for a selected target.                         |
| Trigger | CLI/TUI invocation such as `std //cell/block/target:action`. |
| Input   | Selector, registry metadata, action definition, PRJ env.     |
| Output  | Executed command or stable failure.                          |

Steps:

1. Paisano TUI/CLI loads `#__std.init.<system>` as lightweight metadata and may
   cache it for list/completion/TUI use.
2. Resolve selector into Cell, Cell Block, Target, and Action.
3. Resolve the runnable action derivation at
   `#__std.actions.<system>.<cell>.<block>.<target>.<action>`.
4. Build or realize the action derivation with Nix.
5. Set the PRJ-spec environment before handing control to the action.
6. Validate PRJ env in `mkCommand`.
7. Inject declared runtime dependencies into `PATH` if provided.
8. Execute the action.
9. Surface success or failure through the command's stable output.

Invariants:

- The selector grammar remains `//cell/block/target:action`.
- Registry discovery stays separate from action realization: `init` is cheap,
  `actions` may build derivations.
- Action scripts are shellchecked and dry-run checked when built.
- Runtime dependencies should be declared in the action dependency list.
- Actions should not assume ambient global tools unless that is explicitly the
  contract.

## Workflow: use optional integration

| Field   | Description                                                    |
| ------- | -------------------------------------------------------------- |
| Purpose | Activate vertical tooling only when a downstream repo opts in. |
| Trigger | A library or Block Type needs an optional input.               |
| Input   | `inputs.<tool>`, often defaulting to `blank`.                  |
| Output  | Tool adapter or actionable `requireInput` failure.             |

Steps:

1. Adapter requests the optional input.
2. `requireInput` checks whether the input is still `blank`.
3. If missing, emit a remediation message telling the user what to add to
   `flake.nix`.
4. If present, translate upstream API into the smaller std adapter surface.

## Workflow: update agent-facing knowledge

| Field   | Description                                                           |
| ------- | --------------------------------------------------------------------- |
| Purpose | Keep repo-local docs legible to agents as code evolves.               |
| Trigger | Architecture, Block Type, dependency, or validation behavior changes. |
| Input   | Changed source files and affected docs/manifests.                     |
| Output  | Updated docs, manifests, generated snapshots, and validation results. |

Steps:

1. Update the smallest relevant architecture or agent doc.
2. Update the nearest manifest under `docs/manifests/`.
3. Regenerate or update `docs/generated/*` if source inventories changed.
4. Run `tooling/check-agent-knowledge.sh`.
5. Run formatting/build/test checks appropriate to the change.

## Review questions

- Is the workflow understandable without reading every implementation detail?
- Are pure decisions separate from edge effects?
- Are failures domain-significant, input/contract problems, or operational
  failures?
- Is the workflow visible to agents through docs, registry metadata, or checks?

## Related docs

- `std-domain-model.md`
- `action-runtime.md`
- `invariants.md`
- `docs/agent/validation-harness.md`
