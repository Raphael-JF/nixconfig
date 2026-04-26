{
    description = "Composable VSCodium";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
    };

    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            makeCodium = import ./make-codium.nix { inherit pkgs; };

        in {
            packages.${system} = makeCodium.packages;
        };
}
