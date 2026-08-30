{ pkgs, config, lib, ... }:
{
  options.packages.gaming.enable = lib.mkEnableOption "Enable gaming packages";
  
  config = lib.mkIf config.packages.gaming.enable {
    
    services.zerotierone.enable = true; # for modding and multiplayer
    environment.systemPackages = [
      pkgs.heroic
      pkgs.discord
      pkgs.prismlauncher
    ];
    programs.steam.enable = true;
  };
}
