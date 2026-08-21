{ ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/core
     
    # services
    ../../modules/services/publicIp
    ../../modules/services/icloudBackup
    ../../modules/services/backup.nix
    ../../modules/services/sshServer.nix
    ../../modules/services/homepage
    ../../modules/services/nextcloud
    #../../modules/services/forgejo.nix
  ];
  services.homepage.enable = true;
  services.nextcloud.enable = true;
  services.sshServer.enable = true;
  services.publicIp.enable = true;
  services.backup.devices = {
    enable = true;
    backup = {
      device = "/dev/disk/by-id/usb-SMI_USB_DISK_KT202000000000001037-0:0-part1";
      path = "/mnt/backupUSB";
    };
    data = {
      device = "/dev/disk/by-label/backupDisk";
      path = "/data"; 
    };
  };
  services.icloudBackup = {
    enable = true;
    instances.raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };

  system.stateVersion = "26.05";
}
