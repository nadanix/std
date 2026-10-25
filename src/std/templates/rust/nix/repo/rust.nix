# export fenix toolchain as its own package set
{
  inputs,
  cell,
}: let
  inherit (inputs) fenix;
  inherit (inputs.nixpkgs.lib) filterAttrs isDerivation;

  # you may change "default" to any of "[minimal|default|complete|latest]" for variants
  # see upstream fenix documentation for details
  # Keep packages, not helper functions or flake-check metadata.
  rustPkgs = filterAttrs (_: isDerivation) fenix.packages.default;
in
  # add rust-analyzer from nightly, if not present
  if rustPkgs ? rust-analyzer
  then rustPkgs
  else
    rustPkgs
    // {
      inherit (fenix.packages) rust-analyzer;
      toolchain = fenix.packages.combine [
        (builtins.attrValues rustPkgs)
        fenix.packages.rust-analyzer
      ];
    }
