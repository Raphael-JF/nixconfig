{ pkgs, lib, ... }:

{
  imports = [

    ./hardware-configuration.nix
    # ./disko.nix

    ../../modules
  ];
  

  raph = {
    ssh-server.enable = true;

  };
  
  ssh-server.enable = true;
  services.homepage.enable = true;
  services.raphNextcloud.enable = true;
  services.publicIP.enable = true;
  services."backup-usb" = {
    enable = true;
    devices.backup = {
      device = "/dev/disk/by-id/usb-SMI_USB_DISK_KT202000000000001037-0:0-part1";
      path = "/mnt/backupUSB";
    };
    devices.data = {
      device = "/dev/disk/by-label/backupDisk";
      path = "/data"; 
    };
  };
  services.icloudBackup = {
    enable = true;
    instances.raph = {
      savePath = "/data/nextcloud/data/raph/files/Photos";
      appleID = "poweraphael2@gmail.com";
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "desktop-reboot-windows" ''
      set -e
      ssh -t desktop 'sudo efibootmgr -n 0000 && sudo reboot' 
    '')
  ];


  system.stateVersion = "26.05";
}
