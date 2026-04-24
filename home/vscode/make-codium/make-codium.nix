{
  description = "Composable VSCodium";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      projectSituations = import ./project-situations.nix { inherit pkgs; };

      mkVscodium = profile:
        pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscodium.fhsWithPackages (_: profile.packages);

          vscodeExtensions = profile.extensions;
        };

    in {
      packages.${system} = {

        default = mkVscodium projectSituations.default;

        c = mkVscodium projectSituations.c;

        python = mkVscodium projectSituations.python;

        full = mkVscodium projectSituations.full;
      };
    };
}