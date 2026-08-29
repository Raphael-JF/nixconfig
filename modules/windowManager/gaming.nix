{ pkgs, config, lib, ... }:
{
  options.packages.gaming.enable = lib.mkEnableOption "Enable gaming packages";
  
  config = {
    
    services.zerotierone.enable = true; # for modding and multiplayer
    environment.systemPackages = lib.mkIf config.packages.gaming.enable [
      pkgs.heroic
      pkgs.discord
      pkgs.prismlauncher
    ];
    programs.steam.enable = true;
  };
}
