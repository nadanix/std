{
  inputs = {
    # Kept in sync with the root lock by update-subflake.sh.
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = {nixpkgs, ...}: {
    # Only export the package provider to the data cell, not private nixpkgs.
    mdbook-paisano-preprocessor.packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./mdbook-paisano-preprocessor {};
    });
  };
}
