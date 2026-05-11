{
  inputs,
  cell,
}: let
  inherit (inputs.nixpkgs) lib;
  hasSourceRoot = inputs.self ? sourceRoot;
  root = inputs.self.sourceRoot or null;
  source =
    if hasSourceRoot
    then
      lib.fileset.toSource {
        inherit root;
        fileset = root + /source.txt;
      }
    else null;
in {
  default =
    {inherit hasSourceRoot;}
    // (inputs.nixpkgs.lib.optionalAttrs hasSourceRoot {
      sourceRootType = builtins.typeOf root;
      sourceContent = builtins.readFile "${source}/source.txt";
      ignoredExists = builtins.pathExists "${source}/ignored.txt";
    });
}
