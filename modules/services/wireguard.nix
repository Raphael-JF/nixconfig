{ pkgs, ... }:
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;

    privateKeyFile = "/etc/wireguard/private";
    peers = [{
      publicKey = "JuZQh8M+Vq2jGr7aQpOsKNUdjqdRjkuwRf7M8DwI3j4=";
      allowedIPs = [ "10.100.0.2/32" ];
    }];
  };

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall.allowedUDPPorts = [ 51820 ];
  # environment.systemPackages = [ pkgs.wireguard-tools ];
}
