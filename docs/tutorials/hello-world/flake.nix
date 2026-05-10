{
  inputs.std.url = "github:nadanix/std";
  inputs.nixpkgs.url = "nixpkgs";

  outputs = {std, ...} @ inputs:
    std.grow {
      inherit inputs;
      cellsFrom = ./cells;
    };
}
