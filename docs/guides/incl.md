# Include Filter

It is very common that you want to filter your source code in order
to avoid unnecessary rebuilds and increase your cache hits.

Use `nixpkgs.lib.fileset` for this. `std.incl` remains available for compatibility,
but is deprecated.

For example, from a cell block at `nix/backend/packages.nix`:

```nix
{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib) fileset;
  root = ../../src/backend;
in {
  backend = nixpkgs.mkYarnPackage {
    name = "backend";
    src = fileset.toSource {
      inherit root;
      fileset = fileset.unions [
        (root + /app.js)
        (root + /config/config.js)
        /* ... */
      ];
    };
  };
}
```
