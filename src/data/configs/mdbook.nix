let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib stdenv;

  mdbookPaisanoPreprocessorSrc = lib.fileset.toSource {
    root = ../../std/_sources/mdbook-paisano-preprocessor;
    fileset = ../../std/_sources/mdbook-paisano-preprocessor;
  };

  mdbook-paisano-preprocessor = nixpkgs.rustPlatform.buildRustPackage {
    pname = "mdbook-paisano-preprocessor";
    version = "0.4.0";
    src = mdbookPaisanoPreprocessorSrc;
    cargoHash = "sha256-zKOPn1388k42c5FA6+A8I6J+4MFnFn7W/QH/ccqr99g=";
    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [nixpkgs.libiconv];
  };
in {
  hook.mode = "copy"; # let CI pick it up outside of devshell
  packages = [
    nixpkgs.alejandra
    nixpkgs.prettier
    nixpkgs.shfmt
    nixpkgs.taplo
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
