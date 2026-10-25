# SPDX-FileCopyrightText: 2022 The Standard Authors
# SPDX-FileCopyrightText: 2022 Kevin Amado <kamadorueda@gmail.com>
#
# SPDX-License-Identifier: Unlicense
{
  description = "The Nix Flakes framework for perfectionists with deadlines";
  # override downstream with inputs.std.inputs.nixpkgs.follows = ...
  inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.lib.url = "github:nix-community/nixpkgs.lib";
  inputs = {
    call-flake.url = "github:divnix/call-flake";
    nosys.url = "github:divnix/nosys";
  };
  inputs.blank.url = "github:divnix/blank";
  inputs.yants = {
    url = "github:divnix/yants";
    inputs.nixpkgs.follows = "lib";
  };
  inputs.dmerge = {
    url = "github:divnix/dmerge";
    inputs.haumea.follows = "haumea";
    inputs.yants.follows = "yants";
    inputs.nixlib.follows = "lib";
  };
  inputs.haumea = {
    url = "github:nix-community/haumea";
    inputs.nixpkgs.follows = "lib";
  };
  /*
  Auxiliar inputs used in builtin libraries or for the dev environment.
  */
  inputs = {
    # Placeholder inputs that can be overloaded via follows
    n2c.follows = "blank";
    devshell.follows = "blank";
    nixago.follows = "blank";
    terranix.follows = "blank";
    microvm.follows = "blank";
    arion.follows = "blank";
  };

  outputs = inputs: let
    inherit (inputs.lib.lib) fileset;
    # bootstrap std
    fwlib = import ./src/std/fwlib.nix {
      inputs = inputs // {nixpkgs = inputs.nixpkgs.legacyPackages // {inherit (inputs.nixpkgs) lib;};};
      cell = {};
    };
    # load fwlib again through the framework
    # to enable input overloading for blocktypes
    fwlib' = fwlib.pick (fwlib.grow {
      inherit inputs;
      cellsFrom = fileset.toSource {
        root = ./src;
        fileset = ./src/std;
      };
      cellBlocks = [(fwlib.blockTypes.functions "fwlib")];
    }) ["std" "fwlib"];

    std = {
      # the framework's basic top-level tools
      inherit (inputs) yants dmerge;
      inherit (fwlib') pick harvest winnow;
      inherit (fwlib') blockTypes actions dataWith flakeModule grow growOn findTargets incl;
    };
  in
    assert inputs.nixpkgs.lib.assertMsg ((builtins.compareVersions builtins.nixVersion "2.13") >= 0) "The truth is: you'll need a newer nix version to use Standard (minimum: v2.13).";
      (import ./dogfood.nix (inputs
        // {
          std = std // {inherit (inputs.self) narHash;};
        }))
      std;
}
