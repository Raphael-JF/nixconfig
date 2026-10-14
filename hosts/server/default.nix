{ pkgs, lib, ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/core
    ../../modules/dev
     
    # services
    ../../modules/services/publicIP
    ../../modules/services/icloudBackup
    ../../modules/services/backup-usb
    ../../modules/services/backupPostgresql.nix
    ../../modules/services/sshServer.nix
    ../../modules/services/homepage
    ../../modules/services/nextcloud
    ../../modules/services/recipiz.nix
    ../../modules/services/tv
    ../../modules/remote-desktop.nix
    ../../modules/services/postgresql.nix
    ../../modules/services/wireguard.nix

    #../../modules/services/forgejo.nix
  ];
  
  services.homepage.enable = true;
  services.raphNextcloud.enable = true;
  services.sshServer.enable = true;
  services.publicIP.enable = true;
  services.backupUsb = {
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
      appleID = "poweraphael2@gmail.com";
    };
  };


  system.stateVersion = "26.05";
}
