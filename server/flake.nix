{
  description = "raph's NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
 
    my-nvim = {
        url = "path:./packages/nvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs:
  let
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs hostname; };
      modules = [
        inputs.disko.nixosModules.disko
        ./hosts/${hostname}
      ];
    };
  in
  {
    nixosConfigurations.server = mkHost "server";
    nixosConfigurations.laptop = mkHost "laptop";
  };
}
