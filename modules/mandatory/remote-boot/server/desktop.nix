{ pkgs, ... }:

{

  networking.interfaces.enp7s0.wakeOnLan.enable = true;

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
        (builtins.readFile ../../../../public-ssh-keys/server.pub)
      ];
    };

  };
}
