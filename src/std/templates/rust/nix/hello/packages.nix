{
  inputs,
  cell,
}: let
  inherit (inputs) cells;
  inherit (inputs.nixpkgs.lib) fileset;

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
in {
  # sane default for a binary package
  default = crane.buildPackage {
    src = fileset.toSource {
      root = ../..;
      fileset = fileset.unions [../../Cargo.lock ../../Cargo.toml ../../src];
    };
  };
}
