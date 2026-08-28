{
  description = "raph's NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
 
    my-nvim.url = "path:./packages/nvim";
    my-nvim.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ...}@inputs:
  let

    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs hostname; };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        ./hosts/${hostname}
      ];

    };
  in
  {
    devShells.x86_64-linux = { 
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.nil
        ];
      };
    };
    nixosConfigurations.server = mkHost "server";
    nixosConfigurations.laptop = mkHost "laptop";
    nixosConfigurations.desktop = mkHost "desktop";
  };
}

