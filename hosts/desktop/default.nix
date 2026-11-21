{ pkgs, globals,... }:
{  
  imports = [
    ./hardware-configuration.nix 
    # ./disko.nix

    ../../modules
  ];
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/209dd75b-2e77-4b3b-9171-0290e7636c3c";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/A415-A72A";
      fsType = "vfat";
    };

    boot.initrd.luks.devices.cryptroot2.device = globals.desktop.luks-root-part;


    swapDevices = [ ];

    zramSwap = {
     enable = true;
      memoryPercent = 25;
      algorithm = "zstd";
    };

    
    raph.os-shared.device = "/dev/disk/by-uuid/FB1D-3309";


    # run kitty at startup
    environment.etc."xdg/autostart/kitty.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kitty
      Exec=${pkgs.kitty}/bin/kitty
      X-GNOME-Autostart-enabled=true
    '';

    #

    services.displayManager.autoLogin = {
      enable = true;
      user = "raph";
    };


    system.stateVersion = "26.05";

  };
}
