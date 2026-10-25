{
  inputs = {
    # Private inputs; std itself is injected by dogfood.nix.
    nixpkgs.url = "github:nixos/nixpkgs";
    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";
    namaka.url = "github:nix-community/namaka";
    namaka.inputs.haumea.follows = "haumea";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    # Private transitive inputs: full updates must not reuse upstream locks.
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    systems.url = "github:nix-systems/default";

    # injected inputs to override std's defaults
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.follows = "";
    nixago.inputs.flake-utils.follows = "flake-utils";
    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = i: builtins.removeAttrs i ["self" "nixpkgs" "haumea" "flake-utils" "systems"];
}
