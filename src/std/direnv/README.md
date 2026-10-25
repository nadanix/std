# Standard direnv support

`lib.sh` provides `use env` and `use envreload` for Standard devshell targets.
It discovers the `__std` registry, builds the selected `enter` action, maintains
profiles in `PRJ_DATA_HOME` and watches the selected Cell Blocks.

## Provenance

Imported from [paisano-nix/direnv](https://github.com/paisano-nix/direnv/tree/bd36f51b9d566d8a36e230dab638abf3074625c3),
revision `bd36f51b9d566d8a36e230dab638abf3074625c3`. The original file's SHA-256 is
`sha256-IgQhKK7UHL1AfCUntJO2KCaIDJQotRnK2qC4Daxk+wI=`.
Its SPDX copyright and Unlicense notices are retained; the license text is in
`LICENSES/Unlicense.txt` at the repository root.

Only the usage comments and shell formatting have been adapted. The pinned
`numtide/prj-spec` dependency is unchanged and still downloaded through direnv's
integrity-checked cache. This integration is not a new flake input or a replacement
for direnv itself.

## Loading

This repository loads the library locally and watches it for changes:

```bash
watch_file ./src/std/direnv/lib.sh
. ./src/std/direnv/lib.sh
cellsFrom=src
use envreload //local/shells/default //local/configs
```

`cellsFrom` normally comes from `__std.cellsFrom`. Set it after sourcing the
library when filtered Nix sources do not retain the checkout directory name.
The override affects file watches, not registry evaluation or action selection.

External projects should fetch the published `nadanix/std` library by an immutable
commit URL and content hash, rather than copying it into each project. Publish the
library commit before updating consumers to that revision. A library update needs
an explicit revision/hash update in each consumer; do not use a moving branch URL.

## Validation

```sh
nix build .#checks.x86_64-linux.direnv
```

The check runs Bash syntax checks, ShellCheck and isolated behavioral tests with
mocked direnv/Nix commands. It covers registry and action selection, file/directory
watches, data-home profiles, environment cleanup, build failures and the repository
loader. Real direnv smoke tests should run in temporary checkouts so they do not
alter the developer's approvals or active environment.
