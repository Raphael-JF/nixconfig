{...}:
{
    # ------------------------------------------------------------
    # Wake-on-LAN
    # ------------------------------------------------------------

    networking.interfaces.ENP_INTERFACE.wakeOnLan.enable = true;


    # ------------------------------------------------------------
    # Initrd
    # ------------------------------------------------------------

    boot.initrd = {
      # À remplacer par le module de ta carte Ethernet
      availableKernelModules = [
        "r8169"
      ];

      network = {
        enable = true;

        ssh = {
          enable = true;
          port = 2222;

          hostKeys = [
            "/etc/secrets/initrd/ssh_host_ed25519_key"
          ];
          authorizedKeys = [
            ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID4c+FHbJR0kKQHX3XV6oRUgRQhwKcmwQVMNLY0TWn1p raph@raph-server''
          ];
        };
      };

      systemd.network = {
        enable = true;

        networks."10-ethernet" = {
          matchConfig.Name = "enp7s0";

          networkConfig = {
            DHCP = "ipv4";
          };

          linkConfig.RequiredForOnline = "routable";
        };
      };
    };
      
  networking.interfaces.enp7s0.wakeOnLan.enable = true;
}
