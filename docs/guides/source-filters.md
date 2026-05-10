# Source Filters

It is common to filter source code before passing it to a build tool. This avoids
unnecessary rebuilds and improves cache hits because only the files that are
actual build inputs affect the source hash.

Prefer native `lib.fileset` functions. `std.fileset.include` is a small
convenience helper for the common “root plus selected paths” case.

## Preferred pattern

When Cell code needs to filter sources from the project root, pass an explicit
path from the caller:

```nix
std.growOn {
  inherit inputs;
  cellsFrom = ./nix;
  sourceRoot = ./.;
  cellBlocks = with std.blockTypes; [
    (installables "packages")
  ];
}
```

Then use that path inside Cell Blocks:

```nix
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  root = inputs.self.sourceRoot;
in {
  backend = nixpkgs.mkYarnPackage {
    name = "backend";
    src = std.fileset.include root [
      (root + /backend/app.js)
      (root + /backend/config/config.js)
      # ...
    ];
  };
}
```

`std.fileset.include root paths` is equivalent to:

```nix
nixpkgs.lib.fileset.toSource {
  root = root;
  fileset = nixpkgs.lib.fileset.unions paths;
}
```

Use path values, not stringified paths. `lib.fileset.toSource` intentionally
rejects string roots such as `inputs.self.outPath` or a flake's
`sourceInfo.outPath`; pass `sourceRoot = ./.;` from the caller when Cell Blocks
need a repo-root path. `sourceRoot` is intentionally absent unless
configured, because `cellsFrom` and the project source root are different
concepts.
