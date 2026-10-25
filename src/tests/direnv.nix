{
  runCommand,
  bash,
  shellcheck,
}:
runCommand "std-direnv-tests" {
  nativeBuildInputs = [bash shellcheck];
} ''
  bash -n ${../std/direnv/lib.sh} ${../../.envrc} ${../../tests/direnv.sh}
  shellcheck ${../std/direnv/lib.sh} ${../../tests/direnv.sh}
  bash ${../../tests/direnv.sh} ${../std/direnv/lib.sh} ${../../.envrc}
  touch "$out"
''
