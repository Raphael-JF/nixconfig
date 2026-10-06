{ pkgs, ... }:
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/etc/wireguard/private";
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall.allowedUDPPorts = [ 51820 ];
  # environment.systemPackages = [ pkgs.wireguard-tools ];
}
