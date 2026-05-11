{
  inputs,
  std,
}: let
  inherit (inputs.lib.lib) fileset;
  inherit (std) harvest pick;

  # Inputs that belong to the public std framework surface. Dogfood manifests may
  # mention these only to make their private locks coherent; they must not shadow
  # the root framework inputs when the manifests are loaded back into this flake.
  frameworkInputNames = [
    "self"
    "std"
    "nixpkgs"
    "lib"
    "blank"
    "call-flake"
    "nosys"
    "yants"
    "dmerge"
    "haumea"
  ];

  loadDogfoodInputs = flakeDir:
    builtins.removeAttrs (inputs.call-flake flakeDir).outputs frameworkInputNames;

  localInputs = loadDogfoodInputs ./src/local;
  testInputs = loadDogfoodInputs ./src/tests;

  stdBootstrapInput = std // {inherit (inputs.self) narHash;};

  mkStdOutputs = extraInputs: let
    stdGraph = std.grow {
      inputs = inputs // extraInputs // {std = stdBootstrapInput;};
      cellsFrom = fileset.toSource {
        root = ./src;
        fileset = fileset.unions [
          ./src/std
          ./src/lib
          ./src/data
        ];
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
    };
    result =
      stdGraph
      // {
        packages = harvest result [["std" "cli"] ["std" "packages"]];
        templates = pick result ["std" "templates"];
      }
      // std;
  in
    result;

  mkStdFlakeInput = extraInputs: let
    outputs = mkStdOutputs extraInputs;
  in
    outputs
    // {
      inherit outputs;
      inputs = inputs // extraInputs // {std = stdBootstrapInput;};
      sourceInfo = inputs.self.sourceInfo;
      outPath = inputs.self.outPath;
      _type = "flake";
      inherit (inputs.self) narHash;
    };

  publicStd = mkStdOutputs {};
  localStd = mkStdFlakeInput localInputs;
  testStd = mkStdFlakeInput testInputs;

  localGraph = std.growOn {
    inputs = inputs // localInputs // {std = localStd;};
    cellsFrom = fileset.toSource {
      root = ./src;
      fileset = ./src/local;
    };
    nixpkgsConfig = {allowUnfree = true;};
    cellBlocks = with std.blockTypes; [
      ## For local use in the Standard repository
      # local
      (devshells "shells" {ci.build = true;})
      (nixago "configs")
      (containers "containers")
    ];
  };

  testGraph = std.growOn {
    inputs = inputs // testInputs // {std = testStd;};
    cellsFrom = fileset.toSource {
      root = ./src;
      fileset = ./src/tests;
    };
    nixpkgsConfig = {allowUnfree = true;};
    cellBlocks = with std.blockTypes; [
      ## For local use in the Standard repository
      # tests
      (namaka "checks" {ci.check = true;})
    ];
  };
in
  localGraph
  testGraph
  {
    devShells = harvest inputs.self ["local" "shells"];
    checks = harvest inputs.self ["tests" "checks" "snapshots" "check"];
  }
  publicStd
