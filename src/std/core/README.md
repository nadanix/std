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
upstream structure and behavior. `default.nix` replaces the upstream flake wiring.
The imported tests live in `tests/core-grow` and `tests/core-soil`; their adapters
use Standard's test inputs and the current action signature. Snapshots cover the
systems and registry fields produced by the pinned implementation.

`nosys`, `call-flake` and `yants` remain explicit external dependencies. The CLI
and documentation preprocessor are separate components and are not vendored here.
