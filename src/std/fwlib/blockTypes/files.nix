{root}:
/*
Use the Files Blocktype for any text data.

Available actions:
  - explore
*/
let
  inherit (root) mkCommand;
in
  name: {
    inherit name;
    type = "files";
    actions = {
      currentSystem,
      fragment,
      fragmentRelPath,
      target,
      inputs,
    }: let
      file = toString target;
      pkgs = inputs.nixpkgs.${currentSystem};
    in [
      (mkCommand currentSystem "explore" "interactively explore with bat" [pkgs.bat] ''
        # The target is a literal path, not a shell expression.
        # shellcheck disable=SC2016
        bat -- ${pkgs.lib.escapeShellArg file}
      '' {})
    ];
  }
