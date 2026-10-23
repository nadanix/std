# refresh private inputs without locking std itself
(cd ./src/local && nix flake lock && git add -f flake.lock) &&
  (cd ./src/tests && nix flake lock && git add -f flake.lock)
