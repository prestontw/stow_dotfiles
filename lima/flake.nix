# After changing inputs, run `just update`; after other edits, run `just apply`.
{
  description = "Single-user NixOS development VM managed by Lima";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixos-lima, ... }:
    let
      system = "aarch64-linux";
    in
    {
      nixosConfigurations.nix-dev = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixos-lima.nixosModules.lima
          ./nixos-lima-config.nix
        ];
      };
    };
}
