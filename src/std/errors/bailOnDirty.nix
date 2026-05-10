{inputs}: body: rev: let
  l = inputs.nixpkgs.lib // builtins;
  ansi = import ./ansi.nix;
  pad = s: let
    n = 17;
    prefix = l.concatStringsSep "" (l.genList (_: " ") (n - (l.stringLength s)));
  in
    prefix + s;
  indent = s: let
    n = 5;
    prefix = l.concatStringsSep "" (l.genList (_: " ") n);
    lines = l.splitString "\n" s;
  in
    "  📝 │ " + (l.concatStringsSep "\n${prefix}│ " lines);
  bail = let
    apply =
      l.replaceStrings
      (map (key: "{${key}}") (l.attrNames ansi))
      (l.attrValues ansi);
  in
    msg:
      throw (apply "\n{202}${msg}{reset}");
in
  if rev == "not-a-commit"
  then
    bail ''
      ─────┬─────────────────────────────────────────────────────────────────────────
        🔥 │ {bold}Prohibitive Dirty Git Tree !{un-bold}
      ─────┼─────────────────────────────────────────────────────────────────────────
      {italic}${indent body}{un-italic}
      ─────┴─────────────────────────────────────────────────────────────────────────''
  else rev
