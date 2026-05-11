# Source Filters

It is common to filter source code before passing it to a build tool. This avoids
unnecessary rebuilds and improves cache hits because only the files that are
actual build inputs affect the source hash.

Use native `lib.fileset` functions for source filtering.

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
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;
  root = inputs.self.sourceRoot;
in {
  backend = nixpkgs.mkYarnPackage {
    name = "backend";
    src = lib.fileset.toSource {
      inherit root;
      fileset = lib.fileset.unions [
        (root + /backend/app.js)
        (root + /backend/config/config.js)
        # ...
      ];
    };
  };
}
```

For `cellsFrom` filtering, use the same native helper directly at the caller
boundary:

```nix
let
  inherit (inputs.nixpkgs) lib;
in
std.grow {
  inherit inputs;
  cellsFrom = lib.fileset.toSource {
    root = ./nix;
    fileset = ./nix/app;
  };
  cellBlocks = with std.blockTypes; [
    (installables "packages")
  ];
}
```

Use path values, not stringified paths. `lib.fileset.toSource` intentionally
rejects string roots such as `inputs.self.outPath` or a flake's
`sourceInfo.outPath`; pass `sourceRoot = ./.;` from the caller when Cell Blocks
need a repo-root path. `sourceRoot` is intentionally absent unless configured,
because `cellsFrom` and the project source root are different concepts.
