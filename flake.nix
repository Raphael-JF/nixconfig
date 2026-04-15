{
  description = "My main nixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-unstable branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager.url = "github:nix-community/home-manager";
    # inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.raph-maison = nixpkgs.lib.nixosSystem {
      modules = [
        # système
        ./system.nix

        # home manager
        home-manager.nixosModules.home-manager

        {
            home-manager.users.raph = import ./home.nix;
        }
        ];
    };
  };
}