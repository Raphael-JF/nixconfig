{ lib, config, globals, ... }:


let
  laptop = globals.laptop;

  homePort = globals.ports.wg-server-home;
  server = globals.server;
in
{
  sops.secrets."wg-home-private" = {
    sopsFile = ../../../secrets/wireguard-keys/server-home.key;
    format = "binary";
  };

  networking.wg-quick.interfaces.wg-home = {
  address = [ "${server.wg-home-ip}/24" ];
    listenPort = homePort;
    autostart = true;

    privateKeyFile =
      config.sops.secrets."wg-home-private".path;

    peers = [
      {
        publicKey = lib.strings.trim (builtins.readFile ../../../secrets/wireguard-keys/laptop-home.pub);
        allowedIPs = [ "${laptop.wg-home-ip}/32" ];
      }
    ];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nat = {
    enable = true;
    externalInterface = "${globals.server.network-interface}";
    internalInterfaces = [ "wg-home" ];
    internalIPs = [ "10.100.0.0/24" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ homePort ];

    # Avec le backend nftables de NixOS
    extraForwardRules = ''
      iifname "wg-home" oifname "${globals.server.network-interface}" accept
    '';
  };
}
