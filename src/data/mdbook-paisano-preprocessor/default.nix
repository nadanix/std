{
  lib,
  rustPlatform,
  libiconv,
  mdbook,
  runCommand,
}: let
  package = rustPlatform.buildRustPackage {
    pname = "mdbook-paisano-preprocessor";
    version = (lib.importTOML ./Cargo.toml).package.version;
    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./Cargo.toml
        ./Cargo.lock
        ./src
        ./assets
        ./templates
      ];
    };

    cargoLock.lockFile = ./Cargo.lock;
    buildInputs = [libiconv];

    passthru.tests.mdbook =
      runCommand "mdbook-paisano-preprocessor-protocol" {
        nativeBuildInputs = [mdbook package];
      } ''
        mdbook-paisano-preprocessor supports html
        if mdbook-paisano-preprocessor supports unsupported; then
          echo "Unexpected support for an unknown renderer" >&2
          exit 1
        fi

        mkdir src
        cat > book.toml <<'EOF'
        [book]
        title = "Preprocessor protocol test"
        [preprocessor.paisano-preprocessor]
        multi = []
        EOF
        printf '# Summary\n\n- [Protocol](protocol.md)\n' > src/SUMMARY.md
        printf '# Protocol\n\nPreprocessor protocol works.\n' > src/protocol.md
        mdbook-paisano-preprocessor install
        grep -q 'assets_version = ' book.toml
        mdbook build
        test -s book/mdbook-paisano-preprocessor.css
        grep -q 'Preprocessor protocol works.' book/protocol.html
        touch "$out"
      '';

    meta = {
      description = "Yield documentation from Paisano-based projects into mdBook";
      homepage = "https://github.com/paisano-nix/mdbook-paisano-preprocessor";
      mainProgram = "mdbook-paisano-preprocessor";
    };
  };
in
  package
