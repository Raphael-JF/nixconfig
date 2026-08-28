{ pkgs, lib, config, ... }:
{
  imports = [
    # ./latexTemplate.nix
  ]; 
  options.packages.development.enable = lib.mkEnableOption "Enable development packages";
  
  config = {
    environment.systemPackages = lib.mkIf config.packages.development.enable [
      pkgs.gnumake
      pkgs.cmake
      (pkgs.writeShellScriptBin "new-flake" ''
        set -euo pipefail

        if [[ -e flake.nix ]]; then
            echo "error: flake.nix already exists" >&2
            exit 1
        fi

        if [[ -e .envrc ]]; then
            echo "error: .envrc already exists" >&2
            exit 1
        fi

        cp "$HOME/nixconfig/devShells/flake.nix" ./flake.nix
        echo "use flake" > .envrc
        git add flake.nix .envrc

        direnv allow

        echo "Created:"
        echo "  flake.nix"
        echo "  .envrc"
      '')
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
