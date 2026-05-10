let
  inherit (inputs) nixpkgs;

  # mdbook-paisano-preprocessor currently speaks the mdBook 0.4 preprocessor
  # protocol. Keep the command on a compatible mdBook until that integration is
  # upgraded for mdBook 0.5+.
  mdbookCompatPkgs = import (builtins.fetchTree {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "ac62194c3917d5f474c1a844b6fd6da2db95077d";
    narHash = "sha256-16KkgfdYqjaeRGBaYsNrhPRRENs0qzkQVUooNHtoy2w=";
  }) {inherit (nixpkgs.stdenv.hostPlatform) system;};
  mdbook =
    if nixpkgs.lib.versionAtLeast nixpkgs.mdbook.version "0.5"
    then mdbookCompatPkgs.mdbook
    else nixpkgs.mdbook;
in {
  data = {};
  output = "book.toml";
  format = "toml";
  hook.extra = d: let
    sentinel = "nixago-auto-created: mdbook-build-folder";
    file = ".gitignore";
    str = ''
      # ${sentinel}
      ${d.build.build-dir or "book"}/**
    '';
  in ''
    # Configure gitignore
    create() {
      echo -n "${str}" > "${file}"
    }
    append() {
      echo -en "\n${str}" >> "${file}"
    }
    if ! test -f "${file}"; then
      create
    elif ! grep -qF "${sentinel}" "${file}"; then
      append
    fi
  '';
  commands = [{package = mdbook;}];
}
