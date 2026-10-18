{ pkgs, config, lib, ... }:
{
  options.packages.gaming.enable = lib.mkEnableOption "Enable gaming packages";
  
  config = lib.mkIf config.packages.gaming.enable {
    
    services.zerotierone.enable = true; # for modding and multiplayer
    environment.systemPackages = [
      pkgs.heroic
      pkgs.discord
      pkgs.prismlauncher
      (pkgs.writeShellScriptBin "autoclicker" ''
        echo "-> Hold [Numpad 8] to spam left click   "
        echo "-> Hold [Numpad 9] to spam right click  "
        echo "Starting autoclicker..."
        exec ${pkgs.theclicker}/bin/theclicker run -d"/dev/input/event0" -c25 -C0 -l72 -r73 -H 
      '')
    ];
    programs.steam.enable = true;
  };
}
