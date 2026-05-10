{
  inputs,
  cell,
}: let
  inherit (inputs) std cells;

  crane = inputs.crane.lib.overrideToolchain cells.repo.rust.toolchain;
  root = inputs.self.sourceRoot;
in {
  # sane default for a binary package
  default = crane.buildPackage {
    src = std.fileset.include root [
      (root + /Cargo.lock)
      (root + /Cargo.toml)
      (root + /src)
    ];
  };
}
