{
  description = "My main nixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ nixpkgs, home-manager, stylix, nix-vscode-extensions, ... }: {
    nixosConfigurations.raph-laptop = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
          ];

          nixpkgs.config.allowUnfree = true;
        })

        ./system.nix

        home-manager.nixosModules.home-manager
        ./home/home.nix

        stylix.nixosModules.stylix
        ./stylix.nix
      ];
    };
  };
}