{
  runCommand,
  adrgen,
  mdbook,
  python3,
  configFile,
}:
runCommand "std-adrgen-tests" {
  nativeBuildInputs = [adrgen mdbook python3];
} ''
  export HOME="$TMPDIR/home"
  mkdir -p "$HOME" docs/explain
  cp ${configFile} adrgen.config.yml
  cp -R ${../../docs/explain/architecture-decision-records} docs/explain/architecture-decision-records
  chmod -R u+w docs
  python3 ${../../tests/adrgen.py}
  touch "$out"
''
