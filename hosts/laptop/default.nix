{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager


    ../../modules/services/backup.nix
    ../../modules/services/icloudBackup
    ../../modules/services/nextcloud
  ];

  packages.development.enable = true; 

  # fileSystems."/run/media/${hostname}/osShared" = {
  #   device = "/dev/disk/by-uuid/3fb95fc1-7f65-4f83-950f-0d0ce50576a7";
  #   fsType = "exfat";
  #   options = [
  #     "x-gvfs-show"
  #     "x-gvfs-name=osShared"
        # "nofail"
        # "noatime"
  #   ];
  # };
  #
  services.backup.devices = {
    backup = {
      device = "/dev/disk/by-label/BackupUSB";
      path = "/mnt/backupUSB";
    };
    data = {
      device = "/dev/disk/by-label/backupDisk";
      path = "/mnt/data"; 
    };
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22   # ssh
    ];
  };

  
  services.icloudBackup.instances = {
    raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };

  services.sshServer.enable = true;


  system.stateVersion = "26.05";
}
