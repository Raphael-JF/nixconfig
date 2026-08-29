{
  description = "raph's NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
 
    myNvim.url = "path:./packages/nvim";
    # myNvim.inputs.nixpkgs.follows = "nixpkgs";

    latexTemplates.url = "github:Raphael-JF/Latex-templates"; 
    latexTemplates.inputs.nixpkgs.follows = "nixpkgs";

    sopsNix.url = "github:Mic92/sops-nix";
    sopsNix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ...}@inputs:
  let

    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs hostname; };
      modules = [
        inputs.disko.nixosModules.disko
        inputs.sopsNix.nixosModules.sops
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

