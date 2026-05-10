{
  call-flake,
  lib ? null,
  nosys,
  trivial,
  yants,
  ...
}: let
  nixlib =
    if trivial ? lib
    then trivial.lib
    else if lib != null && lib ? lib
    then lib.lib
    else throw "std.paisano: nixpkgs lib is required";
  l = nixlib // builtins;
  deSystemize = nosys.lib.deSys;

  paths = import ../_sources/paisano-core/paths.nix;
  types = import ../_sources/paisano-core/types {inherit l yants paths;};
in {
  inherit (import ../_sources/paisano-core/soil {inherit l;}) pick harvest winnow;
  inherit (import ../_sources/paisano-core/grow {inherit l deSystemize call-flake paths types;}) grow growOn;

  isDirty = rev: rev == "not-a-commit";
}
