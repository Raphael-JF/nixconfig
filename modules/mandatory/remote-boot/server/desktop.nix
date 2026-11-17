{ pkgs, ... }:

{
  boot.initrd = {
    systemd = {
      # enable = true;

      extraBin.cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";

      network = {
        enable = true;

        networks."20-wired" = {
          matchConfig.Name = "enp7s0";
          networkConfig.DHCP = "ipv4";
        };
      };
    };

    availableKernelModules = [ "r8169" ];

    network.ssh = {
      enable = true;
      port = 2222;

      hostKeys = [
        "/etc/secrets/initrd/ssh_host_ed25519_key"
      ];

      authorizedKeys = [
        # Clé publique SSH du serveur
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE/Iq7r0Wu4GXmPHwMmGAiMW5UpkoqfdadisQ75058Hh raph@raph-server"
      ];
    };

  };
}
