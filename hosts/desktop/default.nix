{ lib, pkgs, config,  hostname, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/dev
    ../../modules/windowManager
    

    ../../modules/services/sshServer.nix
  ];
  config = {
    services.sshServer.enable = true;
    packages.development.enable = true; 
    packages.gaming.enable = true;
    
    # run kitty at startup
    environment.etc."xdg/autostart/kitty.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kitty
      Exec=${pkgs.kitty}/bin/kitty
      X-GNOME-Autostart-enabled=true
    '';

    #
    # ===== NVIDIA GRAPHICS =====
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;  # see the note above
    hardware.nvidia.modesetting.enable = true; 
      hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.159.03";
      sha256_64bit = "sha256-MshdmbD2QMlQH2GzndrSCP0CiNAVxPvF/QQ1wHeD+nc=";
      sha256_aarch64 = "sha256-MshdmbD2QMlQH2GzndrSCP0CiNAVxPvF/QQ1wHeD+nc=";
      openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = lib.fakeSha256;
    };
    hardware.nvidia.powerManagement.enable = true;


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
            /etc/secrets/initrd/ssh_host_ed25519_key
          ];

          authorizedKeys = [
            ''command="systemctl default" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGI0Hs4iMAyT0UZkdwTzGQr1+FKTAbig3/gGke8wZIER raph@raph-server''
          ];
        };
      };

      systemd = {
        enable = true;

        network = {
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
    };
      
   networking.interfaces.enp7s0.wakeOnLan.enable = true;



    system.stateVersion = "26.05";

  };
}
