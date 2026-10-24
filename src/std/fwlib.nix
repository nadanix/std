# This Cell Block is the framework lib. It is special.
# To make use of `std` inside `std`, it is bootsrapped separately.
{
  # during bootstrap: no .cells  / don't use
  # during bootstrap: no input is deSystemized
  inputs,
  # during bootstrap: set to {}  / don't use
  cell,
}: let
  inherit (inputs) haumea;
  core = import ./core {
    inherit (inputs) nosys call-flake yants;
    inherit (inputs.nixpkgs) lib;
  };
  fwlib = haumea.lib.load {
    src = ./fwlib;
    inputs =
      (removeAttrs inputs ["self"])
      // {
        inherit core;
        trivial = inputs.nixpkgs;
      };
  };
in
  fwlib // {inherit (core) pick harvest winnow;}
