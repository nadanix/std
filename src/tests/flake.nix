{
  inputs = {
    # Private inputs; std itself is injected by dogfood.nix.
    nixpkgs.url = "github:nixos/nixpkgs";
    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    # injected inputs to override std's defaults
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.follows = "";
    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";
    terranix.inputs.terranix-examples.follows = "";
    terranix.inputs.bats-support.follows = "";
    terranix.inputs.bats-assert.follows = "";
    namaka.url = "github:nix-community/namaka/ecefdd6d1e0e075403a69202c2695f966ea2f412";
    namaka.inputs.haumea.follows = "haumea";
    namaka.inputs.nixpkgs.follows = "nixpkgs";
    makes.url = "github:fluidattacks/makes";
    makes.inputs.nixpkgs.follows = "nixpkgs";
    arion.url = "github:hercules-ci/arion";
    arion.inputs.nixpkgs.follows = "nixpkgs";
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = i: builtins.removeAttrs i ["self" "nixpkgs" "haumea"];
}
