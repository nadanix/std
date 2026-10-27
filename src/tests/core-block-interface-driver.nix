# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense
{
  corePath,
  nixlibPath,
  yantsPath,
  nosysPath,
  cellsFrom,
}: let
  lib = import (nixlibPath + "/lib");
  yants = (import (yantsPath + "/flake.nix")).outputs {nixpkgs = {inherit lib;};};
  core = import corePath {
    inherit lib yants;
    nosys.lib.deSys = import (nosysPath + "/desys.nix");
    # These fixtures have no Cell flakes; never fetch inputs during this check.
    call-flake = _: throw "Unexpected Cell flake in the Block interface test";
  };
  outputs = core.grow {
    cellsFrom = builtins.toPath cellsFrom;
    systems = ["x86_64-linux"];
    inputs = {
      value = 42;
      self.sourceInfo = {
        outPath = "constant-self";
        rev = "constant-rev";
      };
    };
    cellBlocks = map (name: {
      inherit name;
      type = "interface-test";
      cli = false;
    }) ["block" "sibling"];
  };
in
  outputs.x86_64-linux.demo.block
