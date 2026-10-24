{std}: let
  inherit (builtins) readDir toString;
  inherit (std) incl;
  src = ../dogfood;
  expected = {"expr.nix" = "regular";};
in {
  relative = readDir (incl src ["expr.nix"]) == expected;
  absolute = readDir (incl src ["${toString src}/expr.nix"]) == expected;
  path = readDir (incl src [(src + /expr.nix)]) == expected;
  sourceInfo = readDir (incl {outPath = toString src;} ["expr.nix"]) == expected;
  directory = readDir (incl ../. ["dogfood"]) == {dogfood = "directory";};
  empty = readDir (incl src []) == {};
  emptyDirectory = readDir "${incl ../. ["dogfood/missing"]}/dogfood" == {};
  missing = readDir (incl src ["missing"]) == {};
  prefix = readDir (incl src ["expr"]) == {};
  debug = toString ((incl // {debug = true;}) src ["expr.nix"]) == toString (incl src ["expr.nix"]);
}
