#!/usr/bin/env bash
# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense

set -euo pipefail
library=$(realpath "$1")
loader=$(realpath "$2")
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/project with spaces"
cd "$work/project with spaces"
export PRJ_ROOT="$PWD"
export PRJ_DATA_HOME="$PWD/.data"
# The old Rust variant used this instead; the current library must not use it.
export PRJ_STATE_HOME="$PWD/.state"
log="$work/calls"

# Test bootstrap without downloading or sourcing third-party code.
printf ':\n' >"$work/prj-spec.sh"
fetchurl() {
  test "$1" = 'https://raw.githubusercontent.com/numtide/prj-spec/9b0ffcd0fddcb261bcd73ad9dad18a096760b4a0/contrib/direnv'
  test "$2" = 'sha256-54YaaGly6Q0E8GhFT9fB/h9tN1PDERo2/4R4X0Pdi/c='
  printf '%s\n' "$work/prj-spec.sh"
}
log_status() { printf '%s\n' "$*" >&2; }
watch_file() { printf 'file %s\n' "$1" >>"$log"; }
watch_dir() { printf 'dir %s\n' "$1" >>"$log"; }
use() {
  local name="$1"
  shift
  "use_$name" "$@"
}

# The action expands this variable when evaluated, not when written.
# shellcheck disable=SC2016
printf '%s\n' \
  'test "$STD_DIRENV" = 1' \
  'export DIRENV_TEST_ENTERED=1' \
  'export IN_NIX_SHELL=impure' >"$work/enter"
nix() {
  printf '<%s>' "$@" >>"$log"
  printf '\n' >>"$log"
  if [[ $1 == eval ]]; then
    case "${!#}" in
    builtins.currentSystem) printf 'x86_64-linux' ;;
    *'#__std.cellsFrom') printf '%s' "${TEST_CELLS_FROM:-nix}" ;;
    *) return 1 ;;
    esac
  elif [[ $1 == build ]]; then
    if [[ ${FAIL_BUILD:-0} == 1 ]]; then return 1; fi
    printf '%s\n' "$work/enter"
  else
    return 1
  fi
}

mkdir -p nix/repo/shells/default nix/repo/configs nix/repo/packages/app
printf '{}\n' >nix/repo/shells.nix
printf '{}\n' >nix/repo/configs/default.nix
printf '{}\n' >nix/repo/packages/app.nix
registry=
system=
# shellcheck source=/dev/null
. "$library"
test "$registry" = "git+file://$PRJ_ROOT#__std"
test "$system" = x86_64-linux
use_envreload //repo/shells/default //repo/configs //repo/packages/app
for expected in \
  'file nix/repo/shells.nix' \
  'dir nix/repo/shells/default' \
  'file nix/repo/configs/default.nix' \
  'dir nix/repo/configs/' \
  'file nix/repo/packages/app.nix' \
  'dir nix/repo/packages/app'; do
  grep -Fxq "$expected" "$log"
done
grep -Fq "<--profile><$PRJ_DATA_HOME/repo/shells/default/enter-action>" "$log"
grep -Fq "<$registry.actions.x86_64-linux.repo.shells.default.enter>" "$log"
test -d "$PRJ_DATA_HOME/repo/shells/default"
test ! -d "$PRJ_STATE_HOME"
test "$DIRENV_TEST_ENTERED" = 1
test ! -v STD_DIRENV
test ! -v IN_NIX_SHELL
# Watch-only selectors must not build additional shells.
test "$(grep -c '^<build>' "$log")" = 1

if (
  FAIL_BUILD=1
  use_env //repo/shells/default
) <<<'n' >"$work/failure" 2>&1; then
  echo 'A failed build must not enter the environment' >&2
  exit 1
fi
grep -Fq 'command just failed' "$work/failure"

# The local loader must watch checkout files, not a filtered store basename.
mkdir -p src/std/direnv src/local
ln -s "$library" src/std/direnv/lib.sh
printf '{}\n' >src/local/shells.nix
printf '{}\n' >src/local/configs.nix
: >"$log"
TEST_CELLS_FROM=filtered-source
# shellcheck source=/dev/null
. "$loader"
grep -Fxq 'file ./src/std/direnv/lib.sh' "$log"
grep -Fxq 'file src/local/shells.nix' "$log"
grep -Fxq 'file src/local/configs.nix' "$log"
grep -Fq "<$registry.actions.x86_64-linux.local.shells.default.enter>" "$log"
printf 'direnv integration tests passed\n'
