{
  inputs = {
    # Kept in sync with the root lock by update-subflake.sh.
    nixpkgs.url = "github:nixos/nixpkgs";
    mdbook-paisano-preprocessor = {
      url = "github:paisano-nix/mdbook-paisano-preprocessor";
      # Build the source ourselves instead of importing its 2023 Nix toolchain.
      flake = false;
    };
  };
  outputs = {
    nixpkgs,
    mdbook-paisano-preprocessor,
    ...
  }: {
    # Only export the package provider to the data cell, not private nixpkgs.
    mdbook-paisano-preprocessor.packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./mdbook-paisano-preprocessor {
        src = mdbook-paisano-preprocessor;
      };
    });
  };
}
