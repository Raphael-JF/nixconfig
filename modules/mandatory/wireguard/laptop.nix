{ config, lib, globals, ... }:

let
  laptop = globals.laptop;
  desktop = globals.desktop;

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

  # Les clés sont déchiffrées à l'exécution, pas dans le Nix store.
  sops.templates."wireguard-nm.env" = {
    content = ''
      WG_GAMING_PRIVATE=${config.sops.placeholder."wg-gaming-private"}
      WG_HOME_PRIVATE=${config.sops.placeholder."wg-home-private"}
    '';
  };

  networking.firewall.checkReversePath = "loose";

  networking.networkmanager = {
    enable = true;

    ensureProfiles = {
      environmentFiles = [
        config.sops.templates."wireguard-nm.env".path
      ];

      profiles = {
        wg-gaming = {
          connection = {
            id = "wg-gaming";
            type = "wireguard";
            interface-name = "wg-gaming";
            autoconnect = false;
          };

          wireguard = {
            "private-key" = "$WG_GAMING_PRIVATE";
            "private-key-flags" = 0;
          };

          "wireguard-peer.${desktopKey}" = {
            endpoint = "${globals.server-url}:${toString gamingPort}";
            "allowed-ips" = "${desktop.wg-gaming-ip}/32;";
            "persistent-keepalive" = 25;
          };

          ipv4 = {
            method = "manual";
            address1 = "${laptop.wg-gaming-ip}/24";
            "never-default" = true;
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
            "private-key" = "$WG_HOME_PRIVATE";
            "private-key-flags" = 0;

            # Gère la route par défaut et les règles de routage.
            "ip4-auto-default-route" = true;
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
            dns = "1.1.1.1;9.9.9.9;";
            dns-priority = -50;
          };

          ipv6.method = "disabled";
        };
      };
    };
  };
}
