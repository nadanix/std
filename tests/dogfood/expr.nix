{
  inputs,
  std,
}: let
  readLock = path: builtins.fromJSON (builtins.readFile path);
  locks = {
    root = readLock ../../flake.lock;
    local = readLock ../../src/local/flake.lock;
    tests = readLock ../../src/tests/flake.lock;
    data = readLock ../../src/data/flake.lock;
  };
  inputNode = lock: name: lock.nodes.${lock.nodes.${lock.root}.inputs.${name}};
  nixpkgsPin = lock: (inputNode lock "nixpkgs").locked;
  flakeFiles = [
    ../../flake.nix
    ../../src/local/flake.nix
    ../../src/tests/flake.nix
    ../../src/data/flake.nix
    ../../src/std/templates/minimal/flake.nix
    ../../src/std/templates/rust/flake.nix
    ../../docs/tutorials/hello-world/flake.nix
    ../../docs/tutorials/hello-moon/flake.nix
  ];
  floatingReference = input: !(input ? rev || input ? ref || input ? narHash);
  floatingInput = input:
    floatingReference input
    && (!(input ? url) || builtins.match "(github:[^/]+/[^/?#]+|git\\+https://[^?#]+)" input.url != null)
    && builtins.all floatingInput (builtins.attrValues (input.inputs or {}));
  privateInputNames = ["nixpkgs" "haumea" "haskell-flake" "flake-utils" "systems" "import-tree" "spectrum"];
  documentationFlake = import ../../src/data/flake.nix;
  documentation = documentationFlake.outputs {nixpkgs = std.inputs.nixpkgs;};
  documentationPackage = documentation.mdbook-paisano-preprocessor.packages.${inputs.nixpkgs.system}.default;

  check = name: let
    dir = ../../src + "/${name}";
    flake = import (dir + "/flake.nix");
    lock = builtins.fromJSON (builtins.readFile (dir + "/flake.lock"));
  in
    !(flake.inputs ? std)
    && !(lock.nodes.${lock.root}.inputs ? std)
    && flake.outputs ({self = null;}
      // builtins.listToAttrs (map (name: {
        inherit name;
        value = null;
      }) (builtins.filter (name: flake.inputs ? ${name}) privateInputNames)))
    == {};
in {
  currentSource = std.outPath == toString ../..;
  frameworkInputs = std.inputs.nixpkgs.outPath == inputs.nixpkgs.outPath;
  privateInputs = std.inputs.namaka.outPath == inputs.namaka.outPath;
  localCore = !(std.inputs ? paisano) && !(inputs ? paisano) && !(inputs ? core);
  localCli = !(std.inputs ? paisano-tui) && !(inputs ? paisano-tui);
  cliSource = builtins.readFile (std.std.cli.std.src + /go.mod) == builtins.readFile ../../src/std/cli/go.mod;
  cleanRevision = std.std.errors.bailOnDirty "test" "constant-rev" == "constant-rev";
  dirtyRevision = !(builtins.tryEval (std.std.errors.bailOnDirty "test" "not-a-commit")).success;
  local = check "local";
  tests = check "tests";
  floatingFlakeInputs = builtins.all (path: builtins.all floatingInput (builtins.attrValues (import path).inputs)) flakeFiles;
  floatingLockInputs = builtins.mapAttrs (_: lock:
    builtins.all (node: floatingReference (node.original or {})) (builtins.attrValues lock.nodes))
  locks;
  nixpkgsPins = builtins.mapAttrs (_: lock: nixpkgsPin lock == nixpkgsPin locks.root) locks;
  nixpkgsNodes = builtins.mapAttrs (_: lock:
    builtins.length (builtins.filter (node: (node.locked.repo or null) == "nixpkgs") (builtins.attrValues lock.nodes)))
  locks;
  localDocumentation = !(documentationFlake.inputs ? mdbook-paisano-preprocessor) && !(locks.data.nodes.${locks.data.root}.inputs ? mdbook-paisano-preprocessor);
  documentationProvider = builtins.attrNames documentation == ["mdbook-paisano-preprocessor"];
  documentationSource = builtins.readFile (documentationPackage.src + /Cargo.toml) == builtins.readFile ../../src/data/mdbook-paisano-preprocessor/Cargo.toml;
}
