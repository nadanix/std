# SPDX-FileCopyrightText: 2022 The Standard Authors
#
# SPDX-License-Identifier: Unlicense
{
  lib,
  nosys,
  call-flake,
  yants,
}: let
  l = lib // builtins;
  deSystemize = nosys.lib.deSys;
  paths = import ./paths.nix;
  types = import ./types {inherit l yants paths;};
in {
  inherit types;
  inherit (import ./soil {inherit l;}) pick harvest winnow;
  inherit (import ./grow {inherit l deSystemize paths types call-flake;}) grow growOn;
}
