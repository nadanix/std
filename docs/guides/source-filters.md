# Source Filters

It is common to filter source code before passing it to a build tool. This avoids
unnecessary rebuilds and improves cache hits because only the files that are
actual build inputs affect the source hash.

Prefer native `lib.fileset` functions. `std.fileset.include` is a small
convenience helper for the common “root plus selected paths” case.

## Preferred pattern

```nix
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs std;
  root = ./backend;
in {
  backend = nixpkgs.mkYarnPackage {
    name = "backend";
    src = std.fileset.include root [
      (root + /app.js)
      (root + /config/config.js)
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
rejects string roots such as `inputs.self.outPath`; use a path literal relative
to the Nix file instead.
