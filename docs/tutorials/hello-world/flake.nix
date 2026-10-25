{
  inputs.std.url = "github:nadanix/std";
  inputs.nixpkgs.url = "github:nixos/nixpkgs";

  outputs = {std, ...} @ inputs:
    std.grow {
      inherit inputs;
      cellsFrom = ./cells;
    };
}
