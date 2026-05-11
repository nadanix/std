{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (inputs.nixpkgs) lib;

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
  root = inputs.self.sourceRoot;
in {
  # sane default for a binary package
  default = crane.buildPackage {
    src = lib.fileset.toSource {
      inherit root;
      fileset = lib.fileset.unions [
        (root + /Cargo.lock)
        (root + /Cargo.toml)
        (root + /src)
      ];
    };
  };
}
