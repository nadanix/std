{
  lib ? null,
  trivial,
  ...
}: let
  nixlib =
    if trivial ? lib && trivial.lib ? fileset
    then trivial.lib
    else if lib != null && lib ? lib && lib.lib ? fileset
    then lib.lib
    else throw "std.fileset: nixpkgs lib.fileset is required";

  inherit (nixlib) fileset;

  include = root: paths:
    fileset.toSource {
      inherit root;
      fileset = fileset.unions paths;
    };
in
  fileset
  // {
    inherit include;
  }
