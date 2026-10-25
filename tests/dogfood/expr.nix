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
    && flake.outputs {
      self = null;
      nixpkgs = null;
      haumea = null;
    }
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
  nixpkgsPins = builtins.mapAttrs (_: lock: nixpkgsPin lock == nixpkgsPin locks.root) locks;
  nixpkgsNodes = builtins.mapAttrs (_: lock:
    builtins.length (builtins.filter (node: (node.locked.repo or null) == "nixpkgs") (builtins.attrValues lock.nodes)))
  locks;
  localDocumentation = !(documentationFlake.inputs ? mdbook-paisano-preprocessor) && !(locks.data.nodes.${locks.data.root}.inputs ? mdbook-paisano-preprocessor);
  documentationProvider = builtins.attrNames documentation == ["mdbook-paisano-preprocessor"];
  documentationSource = builtins.readFile (documentationPackage.src + /Cargo.toml) == builtins.readFile ../../src/data/mdbook-paisano-preprocessor/Cargo.toml;
}
