{
  lib,
  pkgs,
  runCommand,
  writeShellScriptBin,
  std,
}: let
  system = pkgs.stdenv.hostPlatform.system;
  captureBat = writeShellScriptBin "bat" ''
    printf '%s\0' "$@" > "$ARGS_FILE"
  '';
  actionFor = bat: target:
    (builtins.head ((std.blockTypes.files "files").actions {
      inherit target;
      currentSystem = system;
      fragment = "tests.files.literal-path";
      fragmentRelPath = "tests/files/literal-path";
      inputs.nixpkgs.${system} = pkgs // {inherit bat;};
    }))
    .command;
  paths = [
    "file/path"
    "file with spaces.txt"
    "single'quote.txt"
    "double\"quote.txt"
    "\${HOME}.txt"
    "$(touch injected).txt"
    "file; touch injected"
    "wildcard-*.txt"
    "line\nbreak.txt"
    "tab\tname.txt"
    "--help"
  ];
in
  runCommand "std-files-explore-tests" {} ''
    export PRJ_ROOT="$PWD"
    export ARGS_FILE="$PWD/args"
    touch wildcard-match.txt

    ${lib.concatMapStringsSep "\n" (file: ''
        printf '%s\0' -- ${lib.escapeShellArg file} > expected
        ${actionFor captureBat file}
        cmp expected "$ARGS_FILE"
      '')
      paths}
    test ! -e injected

    # Exercise the real dependency too: --help is a filename, not a bat option.
    export HOME="$PWD/home"
    mkdir -p "$HOME"
    export BAT_STYLE=plain BAT_PAGER=cat BAT_CONFIG_PATH=/dev/null NO_COLOR=1
    printf 'literal file contents\n' > ./--help
    ${actionFor pkgs.bat "--help"} > actual
    cmp ./--help actual
    touch "$out"
  ''
