{...}:
{
  # wireguard
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.2/24" ];

    privateKeyFile = "/etc/wireguard/private";

    peers = [{
      publicKey = "oMR66tSfBlUDo2bphrXzMziWea2qidMLq98f3VrmaR8=";
      allowedIPs = [ "192.168.1.104/32" ]; # only talk to this IP, that is my desktop LAN IP that will be forwarded from the server to the desktop
      endpoint = "82.126.172.121:51820";
      persistentKeepalive = 25;
    }];
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };
}
