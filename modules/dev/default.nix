{ pkgs, lib, config, ... }:
{
  imports = [
    ./latexTemplate.nix
    ./llm.nix
  ]; 
  options.packages.development.enable = lib.mkEnableOption "Enable development packages";
  
  config = {
    environment.systemPackages = lib.mkIf config.packages.development.enable [
      pkgs.gnumake
      pkgs.cmake
      pkgs.nil
    ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
