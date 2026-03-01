let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  packages = [
    nixpkgs.alejandra
    nixpkgs.nodePackages.prettier
    nixpkgs.shfmt
    nixpkgs.taplo
  ];

  data = {
    formatter = {
      nix = {
        command = lib.getExe nixpkgs.alejandra;
        includes = ["*.nix"];
      };
      prettier = {
        command = lib.getExe nixpkgs.nodePackages.prettier;
        options = ["--write"];
        includes = [
          "*.css"
          "*.html"
          "*.js"
          "*.json"
          "*.jsx"
          "*.md"
          "*.mdx"
          "*.scss"
          "*.ts"
          "*.yaml"
        ];
      };
      taplo = {
        command = lib.getExe nixpkgs.taplo;
        options = [
          "format"
          "--colors"
          "never"
        ];
        includes = ["*.toml"];
      };
      shell = {
        command = lib.getExe nixpkgs.shfmt;
        options = [
          "-i"
          "2"
          "-s"
          "-w"
        ];
        includes = ["*.sh"];
      };
    };
  };
}
