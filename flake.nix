{
  description = "My main nixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, home-manager, stylix, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.raph-laptop = nixpkgs.lib.nixosSystem {
      modules = [
            ./system.nix
            

            home-manager.nixosModules.home-manager
            ./home/home.nix

            stylix.nixosModules.stylix
            ./stylix.nix
        ];
    };
  };
}