# Action Runtime

## Summary

- Block Type actions are the executable edge of the std model.
- `mkCommand` is the stable action runtime boundary.
- Actions should declare dependencies, validate environment assumptions, and
  keep tool-specific detail near the edge.
- Failures should become clearer and more stable as they move inward.

## Runtime contract

`mkCommand` builds an action command with:

- `name`
- `description`
- dependency list
- shell command body
- optional metadata, such as provisos

`mkCommand` delegates shell construction to nixpkgs' `writeShellApplication`,
then exposes the executable at the action derivation's output path for the
std CLI/TUI contract.

The generated script:

1. uses the Nix runtime shell
2. enables `errexit`, `nounset`, and `pipefail`
3. checks for `PRJ_ROOT`
4. injects declared dependencies into `PATH` through `runtimeInputs`
5. runs shell dry-run and shellcheck checks at build time through nixpkgs

## Action boundary shape

```text
Block Type
  receives target and registry context
  decides which actions exist
  builds mkCommand commands
  hides tool-specific mechanics behind stable action names
```

Examples:

| Action family | Stable action names                               | Edge tool detail                                   |
| ------------- | ------------------------------------------------- | -------------------------------------------------- |
| Installables  | `build`, `install`, `upgrade`, `remove`, `bundle` | `nix build`, `nix profile`, `nix bundle`           |
| Runnables     | `build`, `run`                                    | executable path and `mainProgram`                  |
| Devshells     | `build`, `enter`                                  | `nix print-dev-env`, profile path, shell exec      |
| Containers    | `build`, `print-image`, `publish`, `load`         | `skopeo-nix2container`, Docker/Podman destinations |
| Nixago        | `populate`, `explore`                             | nixago shell hook, `bat`                           |

## Failure taxonomy

| Failure                 | Meaning                                                   | Desired surface                                                            |
| ----------------------- | --------------------------------------------------------- | -------------------------------------------------------------------------- |
| Missing PRJ env         | Action was not run from a std/prj-spec environment.       | Clear message pointing to direnv or std CLI/TUI.                           |
| Missing optional input  | User tried to use a blanked integration.                  | `requireInput` remediation with flake snippet.                             |
| Tool failure            | Edge tool returned non-zero.                              | Preserve useful tool output, but do not reclassify it as core std failure. |
| Unexpected target shape | Block Type received a target missing expected attributes. | Improve Block Type validation or docs near the target contract.            |
| Dirty-tree guard        | Deploy-like action requires clean source revision.        | `bailOnDirty` style failure before edge mutation.                          |

## Action design rules

- Use action names that describe user intent, not implementation detail.
- Keep the dependency list explicit when an action needs runtime tools.
- Put edge-specific protocol or deployment details in the action body, not in the
  core domain model.
- Use provisos or guard prompts for actions with external side effects.
- If a failure recurs, convert it into a stable failure envelope or validation
  check.

## Review questions

- Does this action belong to the Block Type, or is it target-specific behavior?
- Are runtime dependencies declared instead of assumed?
- Does the action check prerequisites before mutating external state?
- Would an agent know how to recover from the failure message?

## Related docs

- `block-type-catalog.md`
- `workflows.md`
- `dependency-contracts.md`
- `docs/vendor/design-context/context/patterns/03-error-and-edge-translation-patterns.md`
