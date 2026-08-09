{ pkgs, config, lib, ... }:
{
  options.gaming.enable = lib.mkEnableOption "Enable gaming packages";
  
  config = {
    
    services.zerotierone.enable = true; # for modding and multiplayer
    environment.systemPackages = lib.mkIf config.gaming.enable [
      pkgs.steam     
      pkgs.heroic
      pkgs.discord
      pkgs.prismlauncher
    ];
  };
}
