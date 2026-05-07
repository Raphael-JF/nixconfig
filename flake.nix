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

  outputs = inputs@{ nixpkgs, home-manager, prismlauncher, nix-vscode-extensions, ... }:
  let
    pkgsForHome = import nixpkgs {
      system = "x86_64-linux";
      overlays = [
        nix-vscode-extensions.overlays.default
      ];
      config.allowUnfree = true;
    };

    mkHome = hostType: home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsForHome;
      modules = [
        ./home/home-manager.nix
      ];
      extraSpecialArgs = {
        raph = {
          inherit hostType;
        };
      };
    };
  in {
    homeConfigurations.raph-laptop = mkHome "laptop";
    homeConfigurations.raph-desktop = mkHome "desktop";

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
        ({ config, ... }: {
          home-manager.extraSpecialArgs = {
            raph = {
              hostType = config.raph.hostType;
            };
          };
        })
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
        ({ config, ... }: {
          home-manager.extraSpecialArgs = {
            raph = {
              hostType = config.raph.hostType;
            };
          };
        })
        ./home/home.nix

      ];
    };
  };
}