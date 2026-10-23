{
  lib,
  rustPlatform,
  libiconv,
  mdbook,
  runCommand,
  src,
}: let
  package = rustPlatform.buildRustPackage {
    pname = "mdbook-paisano-preprocessor";
    version = (lib.importTOML (src + /Cargo.toml)).package.version;
    inherit src;

    # Upstream still targets mdBook 0.4; use the 0.5 preprocessor protocol.
    patches = [./mdbook-0.5.patch];
    cargoLock.lockFile = ./Cargo.lock;
    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';
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
        mdbook build
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
