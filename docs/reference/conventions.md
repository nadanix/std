# Conventions in `std`

In principle, we all want to be able to read code with local reasoning.

However, these few conventions are pure quality of life and
help us to keep our nix code organized.

## Nix File Locations

Nix files are imported from either of these two locations, if present, in this order of precedence:

```
${cellsFrom}/${cell}/${block}.nix
${cellsFrom}/${cell}/${block}/default.nix
```

## Readme File Locations

Readme files are picked up by the TUI in the following places:

```
${cellsFrom}/${cell}/Readme.md
${cellsFrom}/${cell}/${block}.md
${cellsFrom}/${cell}/${block}/Readme.md
${cellsFrom}/${cell}/${block}/${target}.md
```

## Cell Block File Arguments

Each Cell Block is a function and expects the following standardized interface for interoperability:

```nix
{ inputs, cell }: {}
```

Both named parameters are required, without defaults, even when one is unused.
The function returns an attribute set of Targets. The core uses ordinary
`import`: `inputs` and `cell` are parameters, not implicitly injected globals.
Attribute-set Blocks, including callable sets with `__functor`, are rejected.
The fork's [Q2 decision](../discovery/open-questions.md#q2-cell-block-functions-and-attribute-sets)
removed that alternative without a transition period or compatibility flag.

### Migrating an attribute-set Block

Prepend `{ inputs, cell }:` to the **whole expression**, before any `let`.
For example, this legacy Block is no longer accepted:

```nix
let
  inherit (inputs) nixpkgs;
in {
  default = nixpkgs.hello;
}
```

Write it as a function instead:

```nix
{ inputs, cell }: let
  inherit (inputs) nixpkgs;
in {
  default = nixpkgs.hello;
}
```

The rule applies to both `${block}.nix` and `${block}/default.nix`. Import errors
include the Block path and migration guidance, including when a free reference
to `inputs` or `cell` fails before type validation. Keep any code depending on
those parameters inside the function's scope.

This restriction is on **Cell Block entry expressions**, not attribute sets in
general. Target values and the returned Target set remain valid attribute sets.
[`src/std/fwlib/findTargets.nix`](https://github.com/nadanix/std/blob/main/src/std/fwlib/findTargets.nix)
still uses `scopedImport` for individual Target files; that separate loader is
unchanged and is not a compatibility path for attribute-set Blocks.

## The `inputs` argument

The `inputs` argument holds all the de-systemized flake inputs plus a few special inputs:

```nix
{
  inputs = {
    self = {}; # sourceInfo of the current repository
    nixpkgs = {}; # an _instantiated_ nixpkgs
    cells = {}; # the other cells in this repo
  };
}
```

## The `cell` argument

The `cell` argument holds all the different Cell Block targets of the current cell.
This is the main mechanism by which code organization and separation of concern is enabled.

## The `deSytemize`d inputs

All inputs are scoped for the _current_ system, that is derived from the `systems` input list to `std.grow`.
That means contrary to the usual nix-UX, in most cases, you don't need to worry about `system`.

The current system will be "lifted up" one level, while still providing full access to all `systems` for
cross-compilation scenarios.

```nix
# inputs.a.packages.${system}
{
  inputs.a.packages.pkg1 = {};
  inputs.a.packages.pkg2 = {};
  /* ... */
  inputs.a.packages.${system}.pkgs1 = {};
  inputs.a.packages.${system}.pkgs2 = {};
  /* ... */
}
```

## Top-level `system`-scoping of outputs

Contrary to the upstream flake schema, all outputs are `system` spaced at the top-level.
This allows us to uniformly select on the _current_ system and forget about it for most
of the time.

Sometimes `nix` evaluations don't strictly depend on a particular `system`, and scoping
them seems counter-intuitive. But due to the fact that function calls are memoized, there
is never a penalty in actually scoping them. So for the sake of uniformity, we scope them
anyways.

The outputs therefore abide by the following "schema":

```nix
{
  ${system}.${cell}.${block}.${target} = {};
}
```
