{ config, lib, globals,... }:

let 
  laptop = globals.laptop;
  desktop  = globals.desktop;
  gamingPort = globals.ports.wg-desktop-gaming;
  homePort = globals.ports.wg-server-home;

  desktopKey = lib.strings.trim (
    builtins.readFile ../../../secrets/wireguard-keys/desktop-gaming.pub
  );

  serverKey = lib.strings.trim (
    builtins.readFile ../../../secrets/wireguard-keys/server-home.pub
  );
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


  # Utile pour un VPN avec route par défaut
  networking.firewall.checkReversePath = "loose";

  networking.networkmanager = {

    ensureProfiles = {
      profiles = {
        wg-gaming = {
          connection = {
            id = "wg-gaming";
            type = "wireguard";
            interface-name = "wg-gaming";
            autoconnect = false;
          };

          wireguard = {
            "private-key-flags" = 0;
            "fwmark" = homePort;
          };

          "wireguard-peer.${desktopKey}" = {
            endpoint = "${globals.server-url}:${toString gamingPort}";
            "allowed-ips" = "${desktop.wg-gaming-ip}/32;";
            "persistent-keepalive" = 25;
          };

          ipv4 = {
            method = "manual";
            address1 = "${laptop.wg-gaming-ip}/24";
          };

          ipv6.method = "disabled";
        };

        wg-home = {
          connection = {
            id = "wg-home";
            type = "wireguard";
            interface-name = "wg-home";
            autoconnect = false;
          };

          wireguard = {
            "private-key-flags" = 0;
            "fwmark" = homePort;
          };

          "wireguard-peer.${serverKey}" = {
            endpoint = "${globals.server-url}:${toString homePort}";
            "allowed-ips" = "0.0.0.0/0;";
            "persistent-keepalive" = 25;
          };

          ipv4 = {
            method = "manual";
            address1 = "${laptop.wg-home-ip}/24";
            "never-default" = false;
          };

          ipv6.method = "disabled";
        };
      };

      secrets.entries = [
        {
          matchId = "wg-gaming";
          matchType = "wireguard";
          matchSetting = "wireguard";
          key = "private-key";
          file = config.sops.secrets."wg-gaming-private".path;
        }
        {
          matchId = "wg-home";
          matchType = "wireguard";
          matchSetting = "wireguard";
          key = "private-key";
          file = config.sops.secrets."wg-home-private".path;
        }
      ];
    };
  };
}
