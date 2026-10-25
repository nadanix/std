{
  inputs,
  cell,
}: let
  inherit (inputs) cells self;
  inherit (inputs.nixpkgs.lib) fileset;

  crane = (inputs.crane.mkLib inputs.nixpkgs).overrideToolchain cells.repo.rust.toolchain;
  # Cell imports may be filtered independently of the project sources.
  # The flake source is already realized; fileset needs a path value.
  root = /. + builtins.unsafeDiscardStringContext self.outPath;
in {
  # sane default for a binary package
  default = crane.buildPackage {
    src = fileset.toSource {
      inherit root;
      fileset = fileset.unions [(root + "/Cargo.lock") (root + "/Cargo.toml") (root + "/src")];
    };
  };
}
