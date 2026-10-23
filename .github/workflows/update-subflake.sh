#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)

# The root lock is authoritative. Do not independently update nixpkgs in each
# private flake: that can pick different revisions even during a single run.
nixpkgs=$(jq -er '
  .nodes[.root].inputs.nixpkgs as $input
  | .nodes[$input].locked
  | if .type == "github" and .owner and .repo and .rev then
      "github:\(.owner)/\(.repo)/\(.rev)"
    else error("Expected a pinned GitHub nixpkgs input in the root flake.lock")
    end
' "$root/flake.lock")

# Keep the other private pins and never lock std itself. All locks are tracked;
# no staging is needed for Nix to see their updated contents.
for cell in local tests data; do
  nix flake lock "$root/src/$cell" --override-input nixpkgs "$nixpkgs"
done
