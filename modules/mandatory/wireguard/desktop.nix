{ lib, config, globals, ... }:

let
  laptop = globals.laptop;
  desktop  = globals.desktop;
  gamingPort = globals.ports.wg-desktop-gaming;
in
{
  sops.secrets."wg-gaming-private" = {
    sopsFile = ../../../secrets/wireguard-keys/desktop-gaming.key;
    format = "binary";
  };

  networking.wg-quick.interfaces.wg-gaming = {
    address = [ "${desktop.wg-gaming-ip}/24" ];
    listenPort = gamingPort;
    autostart = true;

    privateKeyFile =
      config.sops.secrets."wg-gaming-private".path;

    peers = [
      {
        publicKey = lib.strings.trim (builtins.readFile ../../../secrets/wireguard-keys/laptop-gaming.pub);
        allowedIPs = [ "${laptop.wg-gaming-ip}/32" ];
      }
    ];
  };

  networking.firewall = {
    allowedUDPPorts = [ gamingPort ];

    interfaces.wg-gaming.allowedTCPPorts = [
      47984 47989 47990 48010
    ];

    interfaces.wg-gaming.allowedUDPPorts = [
      47998 47999 48000 48002 48010
    ];
  };
}
