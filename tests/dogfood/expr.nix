{
  inputs,
  std,
}: let
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
  local = check "local";
  tests = check "tests";
}
