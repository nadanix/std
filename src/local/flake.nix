{
  inputs = {
    # private inputs for std's local dogfood environment
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    haumea.url = "github:nix-community/haumea";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    namaka.url = "github:nix-community/namaka";
    namaka.inputs.haumea.follows = "haumea";
    namaka.inputs.nixpkgs.follows = "nixpkgs";

    # injected inputs to override std's defaults in the dogfood std instance
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.follows = "";
    n2c.url = "github:nlewo/nix2container";
    n2c.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = i: builtins.removeAttrs i ["self" "nixpkgs" "haumea"];
}
