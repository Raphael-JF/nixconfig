{
  description = "raph's NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-opencode.url = "github:NixOS/nixpkgs/9fbb54b33e91ee4ca368e35a78e0613c720600b3";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
 
    myNvim.url = "path:./packages/nvim";
    myNvim.inputs.nixpkgs.follows = "nixpkgs";

    latexTemplates.url = "github:Raphael-JF/Latex-templates"; 
    latexTemplates.inputs.nixpkgs.follows = "nixpkgs";
   
    recipiz.url = "github:Raphael-JF/Recipiz";
    recipiz.inputs.nixpkgs.follows = "nixpkgs";

    sopsNix.url = "github:Mic92/sops-nix";
    sopsNix.inputs.nixpkgs.follows = "nixpkgs";
  };

outputs = { self, nixpkgs, ... }@inputs:
  let
    lib = nixpkgs.lib;

    hosts = [ "server" "laptop" "desktop" ];

    mkHost = hostname: lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs hostname;

        pkgs-opencode =
          inputs.nixpkgs-opencode.legacyPackages.x86_64-linux;

        perHost = configs:
          let
            invalidHosts = lib.subtractLists hosts (builtins.attrNames configs);
          in
            assert lib.assertMsg (invalidHosts == [])
              "perHost: unknown hosts: ${lib.concatStringsSep ", " invalidHosts}";
            configs.${hostname} or [];
      };

      modules = [
        inputs.disko.nixosModules.disko
        inputs.sopsNix.nixosModules.sops
        ./hosts/${hostname}
      ];
    };
  in
  {
    nixosConfigurations =
      lib.genAttrs hosts mkHost;
  };
}

