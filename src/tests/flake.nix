{
  inputs = {
    # Private inputs; std itself is injected by dogfood.nix.
    nixpkgs.url = "github:nixos/nixpkgs";
    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    # Arion pins 1.0.0 upstream; use a private floating input instead.
    haskell-flake.url = "github:srid/haskell-flake";
    # Private transitive inputs: full updates must not reuse upstream locks.
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    systems.url = "github:nix-systems/default";
    import-tree.url = "github:vic/import-tree";
    spectrum = {
      url = "git+https://spectrum-os.org/git/spectrum";
      flake = false;
    };

    # injected inputs to override std's defaults
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.follows = "";
    nixago.inputs.flake-utils.follows = "flake-utils";
    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.flake-parts.follows = "flake-parts";
    terranix.inputs.import-tree.follows = "import-tree";
    terranix.inputs.systems.follows = "systems";
    namaka.url = "github:nix-community/namaka";
    namaka.inputs.haumea.follows = "haumea";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";
    arion.inputs.flake-parts.follows = "flake-parts";
    arion.inputs.haskell-flake.follows = "haskell-flake";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    microvm.inputs.spectrum.follows = "spectrum";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };
  outputs = i: builtins.removeAttrs i ["self" "nixpkgs" "haumea" "haskell-flake" "flake-utils" "systems" "import-tree" "spectrum"];
}
