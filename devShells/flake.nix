{
  description = "raph's development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      common = with pkgs; [
        git
        curl
        wget
        jq
        ripgrep
        fd
        tree
      ];

      c = with pkgs; [
        gcc
        gdb
        gnumake
        cmake
      ];
      
      python = with pkgs; [
        (python3.withPackages (ps: with ps; [
          numpy
          scipy
          matplotlib
          pandas
        ]))
      ];

      latex = with pkgs; [
        texliveFull
      ];

      # ─────────────────────────────────────────────
      # ESP32
      # ─────────────────────────────────────────────

      esp32 = with pkgs; [
        esp-idf
        cmake
        ninja
        gcc
        gnumake
        python3
        git
        pkg-config
      ];

    in {
      devShells.${system} = {

        # C
        c = pkgs.mkShell {
          packages = common ++ c;
        };

        # Python
        python = pkgs.mkShell {
          packages = common ++ python;
        };

        # LaTeX
        latex = pkgs.mkShell {
          packages = common ++ latex;
        };

        # ESP32 / ESP-IDF
        esp32 = pkgs.mkShell {
          packages = common ++ esp32;

          shellHook = ''
            echo "ESP32 development environment"
            echo "ESP-IDF: $ESP_IDF_VERSION"
          '';
        };

        # ─────────────────────────────────────────
        # Combined environments
        # ─────────────────────────────────────────

        c-python = pkgs.mkShell {
          packages = common ++ c ++ python;
        };

        full = pkgs.mkShell {
          packages =
            common
            ++ c
            ++ python
            ++ latex
            ++ esp32;
        };

        default = pkgs.mkShell {
          packages = common ++ c ++ python;
        };
      };
    };
}
