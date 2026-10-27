# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense
{
  runCommand,
  nix,
  python3,
  frameworkInputs,
}:
runCommand "std-core-block-interface-tests" {
  nativeBuildInputs = [nix python3];
} ''
  export HOME="$TMPDIR/home"
  mkdir -p "$HOME"
  nix-instantiate --version
  python3 --version
  python3 ${../../tests/core-block-interface.py} \
    --driver ${./core-block-interface-driver.nix} \
    --core ${../std/core} \
    --nixlib ${frameworkInputs.lib} \
    --yants ${frameworkInputs.yants} \
    --nosys ${frameworkInputs.nosys} -v
  touch "$out"
''
