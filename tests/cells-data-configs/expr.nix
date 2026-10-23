{
  nixpkgs,
  std,
}: let
  inherit (nixpkgs) lib;
  inherit (std.data) configs;
  inherit (configs.treefmt.data) formatter;
in {
  treefmtPackages = map lib.getName configs.treefmt.packages;
  mdbookPackages = map lib.getName configs.mdbook.packages;
  prettier = {
    command = formatter.prettier.command == lib.getExe nixpkgs.prettier;
    formatsToml = builtins.elem "*.toml" formatter.prettier.includes;
    inherit (formatter.prettier) options;
  };
  toml = {
    command = formatter.toml.command == lib.getExe nixpkgs.taplo;
    inherit (formatter.toml) includes options;
  };
}
