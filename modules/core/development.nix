{ pkgs, lib, config, ... }:
{
  options.packages.development.enable = lib.mkEnableOption "Enable development packages";
  
  config = {
    environment.systemPackages = lib.mkIf config.packages.development.enable [
      pkgs.gnumake
      pkgs.cmake
      (pkgs.writeShellScriptBin "new-flake" ''
          set -euo pipefail
          cp "$HOME/nixconfig/devShells/flake.nix" ./flake.nix
      '')
    ];
  };
}
