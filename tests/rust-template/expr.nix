{std}: let
  inherit (std.inputs.nixpkgs) lib;
  nixpkgs = {inherit lib;};
  package = name: {
    inherit name;
    type = "derivation";
  };
  rust = import ../../src/std/templates/rust/nix/repo/rust.nix {
    cell = {};
    inputs = {
      inherit nixpkgs;
      fenix.packages = {
        default = {
          cargo = package "cargo";
          toolchain = package "default-toolchain";
          name = "default";
          type = "derivation";
          outputName = "dummy-out";
          outputs = ["dummy-out"];
          withComponents = _: throw "Not a package";
        };
        rust-analyzer = package "rust-analyzer";
        combine = paths:
          assert lib.all lib.isDerivation (lib.flatten paths);
            package "combined-toolchain";
      };
    };
  };
  hello = import ../../src/std/templates/rust/nix/hello/packages.nix {
    cell = {};
    inputs = {
      inherit nixpkgs;
      cells.repo = {inherit rust;};
      self.outPath = builtins.path {path = ./__fixture;};
      crane.mkLib = pkgs:
        assert pkgs ? lib; {
          overrideToolchain = toolchain: {
            buildPackage = args: args // {inherit toolchain;};
          };
        };
    };
  };
in {
  onlyPackages = lib.all lib.isDerivation (builtins.attrValues rust);
  analyzer = rust.rust-analyzer.name == "rust-analyzer";
  toolchain = hello.default.toolchain.name == "combined-toolchain";
  projectSources =
    builtins.readDir hello.default.src
    == {
      "Cargo.lock" = "regular";
      "Cargo.toml" = "regular";
      src = "directory";
    };
  mainSource = builtins.pathExists "${hello.default.src}/src/main.rs";
}
