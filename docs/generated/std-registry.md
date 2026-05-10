# Generated std Registry Snapshot

This is a lightweight snapshot of the public `#__std` registry shape for
`x86_64-linux`. The runtime source of truth is the evaluated flake output:

```bash
nix eval --json --no-write-lock-file .#__std.init.x86_64-linux
```

Top-level registry keys observed:

- `__schema`
- `actions`
- `cellsFrom`
- `ci`
- `init`

## Cell/block/target inventory

| Cell    | Cell Blocks and targets                                                                                                                                                                                                                                                                            |
| ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `local` | `shells:devshells(book\|default)`, `configs:nixago(adrgen\|cog\|conform\|editorconfig\|githubsettings\|lefthook\|mdbook\|treefmt)`, `containers:containers(dev\|vscode)`                                                                                                                           |
| `tests` | `checks:namaka(snapshots)`                                                                                                                                                                                                                                                                         |
| `data`  | `configs:data(adrgen\|cog\|conform\|editorconfig\|githubsettings\|just\|lefthook\|mdbook\|treefmt)`                                                                                                                                                                                                |
| `lib`   | `dev:functions(mkArion\|mkNixago\|mkShell)`, `ops:functions(lazyDerivation\|mkDevOCI\|mkMicrovm\|mkOCI\|mkOperable\|mkOperableScript\|mkSetup\|mkStandardOCI\|mkUser\|readYAML\|writeScript)`, `cfg:anything(adrgen\|cog\|conform\|editorconfig\|githubsettings\|just\|lefthook\|mdbook\|treefmt)` |
| `std`   | `cli:runnables(default\|std)`, `devshellProfiles:functions(default)`, `errors:functions(bailOnDirty\|removeBy\|requireInput)`, `templates:data(minimal\|rust)`                                                                                                                                     |

Update this snapshot when the registry shape, Cells, Cell Blocks, or target
inventory changes.
