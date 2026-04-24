{
  description = "C - IDE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    # 🔗 ton flake VSCodium
    vscodium.url = "path:/home/raph/Desktop/nixconfig/make-codium";
  };

  outputs = { self, nixpkgs, vscodium }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

    in {

      # 🔹 shell principal du projet
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          vscodium.packages.${system}.c   # 👈 choisis ton profil ici
        ];
      };

    };
}