{ config, lib, globals,... }:

let 
  laptop = globals.laptop;
  desktop  = globals.desktop;
  gamingPort = globals.ports.desktop-gaming-wg;
  homePort = globals.ports.server-home-wg;
in 
{
  sops.secrets = {
    "wg-gaming-private" = {
      sopsFile = ../../../secrets/wireguard-keys/laptop-gaming.key;
      format = "binary";
    };

    "wg-home-private" = {
      sopsFile = ../../../secrets/wireguard-keys/laptop-home.key;
      format = "binary";
    };
  };

  networking.wg-quick.interfaces = {
    wg-gaming = {
      address = [ "${laptop.wg-gaming-ip}/24" ];
      autostart = false;

      privateKeyFile =
        config.sops.secrets."wg-gaming-private".path;

      extraOptions.FwMark = homePort;

      peers = [
        {
          publicKey = lib.strings.trim (builtins.readFile ../../../secrets/wireguard-keys/desktop-gaming.pub);
          endpoint = "${globals.server-url}:${gamingPort}";

          allowedIPs = [ "${desktop.wg-gaming-ip}/32" ];
          persistentKeepalive = 25;
        }
      ];
    };

    wg-home = {
      address = [ "${laptop.wg-home-ip}/24" ];
      autostart = false;

      privateKeyFile =
        config.sops.secrets."wg-home-private".path;

      extraOptions.FwMark = homePort;

      peers = [
        {

          publicKey = lib.strings.trim (builtins.readFile ../../../secrets/wireguard-keys/server-home.pub);
          endpoint = "${globals.server-url}:${homePort}";

          allowedIPs = [ "0.0.0.0/0" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
