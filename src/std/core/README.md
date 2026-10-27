# Framework core

Standard maintains its Cells, Cell Blocks and registry engine in-tree.
`default.nix` takes explicit dependencies; this directory is not a flake.
`../fwlib.nix` imports it separately from Haumea and exposes the existing
framework API through `fwlib`.

## Provenance

Imported from [paisano-nix/core](https://github.com/paisano-nix/core/tree/88739c84d308876714322eb9844ede6597c1a580),
revision `88739c84d308876714322eb9844ede6597c1a580`, previously pinned in the root lock.
The upstream license is Unlicense; copyright notices are retained.

`grow/`, `soil/`, `types/`, `paths.nix` and `registry.schema.json` retain their
upstream layout, not a promise of unchanged behavior. `default.nix` replaces the
upstream flake wiring. Subsequent fork decisions include the optional
`object | null` CI metadata schema and function-only Cell Block imports; see
[Q1 and Q2](../../../docs/discovery/open-questions.md).

The core now uses ordinary `import` and rejects attribute-set Blocks, including
callable sets, without a transition period. Errors include the Block path and
[migration guidance](../../../docs/reference/conventions.md#migrating-an-attribute-set-block).
This does not change attribute sets as Target values or the separate
`../fwlib/findTargets.nix` Target-file loader.

The imported tests live in `tests/core-grow` and `tests/core-soil`; their adapters
use Standard's test inputs and the current action signature. The existing
snapshots remain unchanged by the function-only migration. The additional
[`core-block-interface` check](../../../docs/guides/contributing.md#cell-block-interface)
covers rejection and migration diagnostics separately from those snapshots.

`nosys`, `call-flake` and `yants` remain explicit external dependencies. The CLI
and documentation preprocessor are separate components and are not vendored here.
