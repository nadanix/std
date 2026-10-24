{std}: let
  inherit (std) grow;
  inputs = {
    inherit (std.inputs) nixpkgs;
    self.sourceInfo = {
      outPath = "constant-self";
      rev = "constant-rev";
    };
  };
in
  grow {
    inherit inputs;
    cellsFrom = ./__fixture;
    cellBlocks = [
      {
        name = "test-block";
        type = "test-block";
        actions = {
          inputs,
          currentSystem,
          fragment, # sometimes needed when direct invocation on drv is not possible
          fragmentRelPath,
          target,
        }:
          with inputs.nixpkgs; [
            {
              name = "foo-action";
              description = "paisano foo";
              command = pkgs.writeShellScript "foo-action" ''
                echo "I'm Paisano and 42!"
              '';
            }
          ];
      }
    ];
  }
