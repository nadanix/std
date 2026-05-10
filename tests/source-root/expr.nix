{
  inputs,
  std,
}: let
  cellBlocks = with std.blockTypes; [(functions "packages")];
  systems = ["x86_64-linux"];
  growInputs = std.inputs // {self = std;};

  withoutSourceRoot = std.grow {
    inputs = growInputs;
    inherit cellBlocks systems;
    cellsFrom = ./__fixture/nix;
  };

  withSourceRoot = std.grow {
    inputs = growInputs;
    inherit cellBlocks systems;
    cellsFrom = ./__fixture/nix;
    sourceRoot = ./__fixture;
  };
in {
  withoutSourceRoot = withoutSourceRoot.x86_64-linux.app.packages.default;
  withSourceRoot = withSourceRoot.x86_64-linux.app.packages.default;
}
