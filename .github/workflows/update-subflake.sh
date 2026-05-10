#!/usr/bin/env bash
set -euo pipefail

# refresh private dogfood input manifests without updating existing pins
(cd ./src/local && nix flake lock && git add -f flake.lock)
(cd ./src/tests && nix flake lock && git add -f flake.lock)
# continue normally ...
