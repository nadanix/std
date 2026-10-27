# TUI/CLI

#### TUI/CLI:

```console
# TUI
std

# CLI
std //<TAB>
std re-cache # refresh the CLI cache
std list     # show a list of all targets

# Version
std -v
```

## Action arguments

The TUI directs users to the CLI for Actions declared as requiring arguments.
The CLI delegates their validation to the Action/tool itself. This is the
[accepted P-F3 contract](../discovery/open-questions.md#p-f3-argument-handling-in-tui-and-direct-cli).

- **TUI:** there is no argument-entry prompt. Selecting an Action with
  `requiresArgs = true` exits the TUI and, after command assembly, reports that
  it must be run from the command line, without building or executing the Action.
  It does not automatically launch another CLI invocation.
- **Direct CLI:** supplied arguments, including an empty list, are passed to the
  Action; Standard does not enforce `requiresArgs` on this path. For example:

  ```console
  std //cell/block/target:action argument
  std //cell/block/target:action -- --help
  ```

  The second form forwards `--help` to the Action rather than requesting
  Standard's own help. Whether the Action supports it is tool-specific.

The TUI closes before Action execution; subsequent stdout/stderr can appear in
the terminal, not in an embedded output viewer. Running without arguments is not
guaranteed to show help, succeed, or be harmless: inspect the Action/tool's behavior.

#### Help:

```console
❯ std -h
std is the CLI / TUI companion for Standard.

- Invoke without any arguments to start the TUI.
- Invoke with a target spec and action to run a known target's action directly.

Usage:
  std //[cell]/[block]/[target]:[action] [args...]
  std [command]

Available Commands:
  list        List available targets.
  re-cache    Refresh the CLI cache.

Flags:
  -h, --help      help for std
  -v, --version   version for std

Use "std [command] --help" for more information about a command.
```
