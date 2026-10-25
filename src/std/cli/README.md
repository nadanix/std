# Standard CLI/TUI

The Go module in this directory implements Standard's CLI/TUI.
`../cli.nix` builds it as `std`, sets the existing Standard flags and installs
shell completions. There is no separate flake here.

## Provenance

Imported from [paisano-nix/tui](https://github.com/paisano-nix/tui/tree/6461b31e4458dbce655fa1db6d266f666dbdfc4e/src),
revision `6461b31e4458dbce655fa1db6d266f666dbdfc4e`, previously pinned in the root lock.
The module path `github.com/paisano-nix/paisano`, `go.mod` and `go.sum` are retained:
imports of that module resolve locally, not to an external Paisano dependency.

The sources and cache tests retain their upstream structure. Upstream's
`default.md` is Cell Block documentation, not a Go resource; it is omitted to
avoid changing Standard's `cli.default` target documentation.

The upstream license is Unlicense, with BSD-3-Clause code in `cache/`.
Original copyright notices are retained; see `LICENSE` and `cache/LICENSE`.
Both license notices are installed with the package.

`buildGoModule` runs the cache tests during its check phase. To test all packages
in a Go development environment, run `go test ./...` from this directory.
