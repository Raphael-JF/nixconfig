{
  description = "My main nixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
    };


    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs@{ nixpkgs, home-manager, prismlauncher, nix-vscode-extensions, ... }: {
    nixosConfigurations.raph-laptop = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
          ];

          nixpkgs.config.allowUnfree = true;
        })
        ./specific-raph-laptop.nix


        ./system.nix

        home-manager.nixosModules.home-manager
        ./home/home.nix

      ];
    };
    nixosConfigurations.raph-desktop = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [
            nix-vscode-extensions.overlays.default
          ];

          nixpkgs.config.allowUnfree = true;
        })
        (
            { pkgs, ... }:
            {
              environment.systemPackages = [ prismlauncher.packages.${pkgs.system}.prismlauncher ];
            }
          )
        ./specific-raph-desktop.nix

        ./system.nix

        home-manager.nixosModules.home-manager
        ./home/home.nix

      ];
    };
  };
}