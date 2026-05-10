let
  inherit (inputs.nixpkgs) lib;
in
  lib.lazyDerivation or (throw "std.lib.ops.lazyDerivation requires nixpkgs.lib.lazyDerivation; update the nixpkgs input")
