{
  description = "raph's development environments";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
    devShells.${system} = {
      c = pkgs.mkShell {
        packages = with pkgs; [
          gcc
          gdb
          valgrind
          clang-tools
        ];
      };

      python = pkgs.mkShell {
        packages = with pkgs; [
          (python3.withPackages (ps: with ps; [
            numpy
            scipy
            matplotlib
            pandas
          ]))
          pyright
        ];
      };

      java = pkgs.mkShell {
        packages = with pkgs; [
          openjdk
        ];
      };

      latex = pkgs.mkShell {
        packages = with pkgs; [
          texliveFull
          texlab
        ];
      };

      esp32 = pkgs.mkShell {
        packages = with pkgs; [
          platformio
          clang-tools
        ];
      };

      bash = pkgs.mkShell {
        packages = with pkgs; [
          bash-language-server
        ];
      };

      "html-css-js" = pkgs.mkShell {
        packages = with pkgs; [
          vscode-langservers-extracted
          typescript-language-server
        ];
      };

      javascript = pkgs.mkShell {
        packages = with pkgs; [
          nodejs
          typescript-language-server
        ];
      };
    };
  };
}
