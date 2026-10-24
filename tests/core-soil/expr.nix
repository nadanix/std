{std}: let
  inherit (std) growOn harvest winnow pick;
  inputs = {
    inherit (std.inputs) nixpkgs;
    self.sourceInfo = {
      outPath = "constant-self";
      rev = "constant-rev";
    };
  };
  self = growOn {
    inherit inputs;
    cellsFrom = ./__fixture;
    cellBlocks = [
      {
        name = "foo-block";
        type = "another type";
      }
      {
        name = "templates";
        type = "a type";
      }
    ];
  };
in
  # Soil
  {
    foo = harvest self ["foo-cell" "foo-block"];
    fooAndBar = harvest self [
      ["foo-cell" "foo-block"]
      ["bar-cell" "foo-block"]
    ];
    fooAndBar' = winnow (n: v: n == v) self [
      ["foo-cell" "foo-block"]
      ["bar-cell" "foo-block"]
    ];
    libToplevel = harvest self ["foo-cell"];
    libToplevelAndHoistedChildren = harvest self [
      ["foo-cell"]
      ["foo-cell" "foo-block"]
    ];
    templates = pick self ["bar-cell" "templates"];
  }
