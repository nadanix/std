inputs: let
  inherit (inputs) std;
  inherit (inputs.lib.lib) fileset;
  inherit (std) pick harvest;
  grow = name: let
    extraInputs =
      (builtins.getFlake (builtins.unsafeDiscardStringContext
          "path:${inputs.self.outPath}?narHash=${inputs.self.narHash}&dir=src/${name}")).outputs;
    # Inject the current std with this cell's private inputs, without locking itself.
    inputs' = inputs // extraInputs // {inherit self;};
    outputs = (import ./flake.nix).outputs inputs';
    self =
      outputs
      // inputs.self.sourceInfo
      // {
        inherit outputs;
        inherit (inputs.self) sourceInfo;
        inputs = builtins.removeAttrs inputs' ["self"];
      };
  in
    std.growOn {
      inputs = inputs // {std = self;};
      cellsFrom = fileset.toSource {
        root = ./src;
        fileset = ./src + "/${name}";
      };
      nixpkgsConfig = {allowUnfree = true;};
      cellBlocks = with std.blockTypes; [
        ## For local use in the Standard repository
        # local
        (devshells "shells" {ci.build = true;})
        (nixago "configs")
        (containers "containers")
        (namaka "checks" {ci.check = true;})
      ];
    };
in
  (grow "local")
  (grow "tests")
  {
    devShells = harvest inputs.self ["local" "shells"];
    checks = inputs.nixpkgs.lib.mapAttrs (system: checks:
      checks
      // {
        direnv = inputs.nixpkgs.legacyPackages.${system}.callPackage ./src/tests/direnv.nix {};
      }) (harvest inputs.self ["tests" "checks" "snapshots" "check"]);
  }
  (std.grow {
    inherit inputs;
    cellsFrom = fileset.toSource {
      root = ./src;
      fileset = fileset.unions [./src/std ./src/lib ./src/data];
    };
    cellBlocks = with std.blockTypes; [
      ## For downstream use

      # std
      (runnables "cli" {ci.build = true;})
      (functions "devshellProfiles")
      (functions "errors")
      (data "templates")

      # lib
      (functions "dev")
      (functions "ops")
      (anything "cfg")
      (data "configs")
    ];
  })
  {
    packages = harvest inputs.self [["std" "cli"] ["std" "packages"]];
    templates = pick inputs.self ["std" "templates"];
  }
