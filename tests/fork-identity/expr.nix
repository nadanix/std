# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense
{
  nixpkgs,
  std,
}: let
  inherit (nixpkgs) lib;
  root = std.outPath;
  repository = "https://github.com/nadanix/std";
  documentation = "${repository}/blob/main/docs/SUMMARY.md";
  # Split these strings so the policy test does not flag its own definitions.
  upstreamOwner = "divnix";
  upstream = "${upstreamOwner}/std";
  upstreamDocs = "std.${upstreamOwner}.com";
  retiredBranch = "upstream" + "-main";

  # Only attribution and explicit historical evidence may name the old repository.
  # Changelog entries retain old commit/release URLs; std-action is a dependency.
  attribution = {
    "README.md" = [
      "[`${upstream}`][upstream]"
      "[upstream]: https://github.com/${upstream}"
    ];
    ".reuse/dep5" = [
      "Comment: Forked from https://github.com/${upstream}; upstream attribution is preserved."
    ];
    "docs/discovery/open-questions.md" = [
      "[implicit-api-pr]: https://github.com/${upstream}/pull/147"
      "[implicit-api-commit]: https://github.com/${upstream}/commit/4c9c29212983c55ff29b47d1ea1e5459fae51e03"
    ];
  };
  sources = prefix:
    lib.concatLists (lib.mapAttrsToList (name: type: let
      relative = prefix + name;
    in
      if type == "directory"
      then sources (relative + "/")
      else if
        type
        == "regular"
        && relative != "CHANGELOG.md"
        && (lib.any (suffix: lib.hasSuffix suffix name) [".md" ".nix" ".json" ".yml" ".yaml" ".toml" ".cue" ".sh"]
          || name == ".envrc"
          || relative == ".reuse/dep5")
      then [relative]
      else [])
    (builtins.readDir (root + "/${prefix}")));
  stale = relative: let
    allowed = ["${upstream}-action"] ++ (attribution.${relative} or []);
    content = lib.replaceStrings allowed (map (_: "") allowed) (builtins.readFile (root + "/${relative}"));
  in
    lib.any (pattern: lib.hasInfix pattern content) [
      retiredBranch
      upstream
      upstreamDocs
      "${upstreamOwner}%2Fstd"
      ''owner = "${upstreamOwner}"''
      ''"https://github.com/${upstreamOwner}"''
    ];
  configs = std.local.configs;
  # Inspect container metadata without building the development images.
  containers = import ../../src/local/containers.nix {
    inputs = {
      nixpkgs.lib = {};
      std.lib.ops.mkDevOCI = config: config;
    };
    cell.shells.default = {};
  };
  consumerFlakes = [
    ../../src/std/templates/minimal/flake.nix
    ../../src/std/templates/rust/flake.nix
    ../../docs/tutorials/hello-world/flake.nix
    ../../docs/tutorials/hello-moon/flake.nix
  ];
in {
  staleReferences = builtins.filter stale (sources "");
  cliHomepage = std.std.cli.std.meta.homepage == repository;
  changelogOwner = configs.cog.__passthru.data.changelog.owner == "nadanix";
  repositoryHomepage = configs.githubsettings.__passthru.data.repository.homepage == documentation;
  generatedRepositoryHomepage = lib.hasInfix "homepage: ${documentation}" (builtins.readFile ../../.github/settings.yml);
  containerSources = lib.all (container: container.labels.url == repository && container.labels.source == repository) (builtins.attrValues containers);
  consumerInputs = lib.all (path: (import path).inputs.std.url == "github:nadanix/std") consumerFlakes;
  schemaId = (builtins.fromJSON (builtins.readFile ../../src/std/core/registry.schema.json))."$id" == "https://raw.githubusercontent.com/nadanix/std/main/src/std/core/registry.schema.json";
}
