let
  inherit (inputs) nixpkgs;
  mdbook-paisano-preprocessor = inputs.mdbook-paisano-preprocessor.packages.default;
in {
  hook.mode = "copy"; # let CI pick it up outside of devshell
  packages = [
    nixpkgs.alejandra
    nixpkgs.prettier
    nixpkgs.taplo
    nixpkgs.shfmt
    mdbook-paisano-preprocessor
  ];

  data = {
    book = {
      language = "en";
      src = "docs";
      title = "Documentation";
    };
    build = {
      build-dir = "docs/book";
    };
    preprocessor.paisano-preprocessor = {
      before = ["links"];
      registry = ".#__std.init";
    };
  };
}
