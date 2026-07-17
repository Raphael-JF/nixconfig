{
  description = "Didier's NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, disko, ... }:
  let
    system = "x86_64-linux";
  in {

    nixosConfigurations.server =
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [

          disko.nixosModules.disko

          ./hosts/server
        ];
      };
  };
}
