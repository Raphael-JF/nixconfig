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

  networking.firewall = {
    extraForwardRules = ''
      iifname "wg0" oifname "enp0s20f0u2" ip daddr 192.168.1.104 accept
      iifname "enp0s20f0u2" oifname "wg0" ip saddr 192.168.1.104 ct state established,related accept
    '';
    allowedUDPPorts = [ 51820 ];
  };

  networking.nat = {
    enable = true;
    externalInterface = "enp0s20f0u2";
    internalInterfaces = [ "wg0" ];
  };

  # environment.systemPackages = [ pkgs.wireguard-tools ];

}
