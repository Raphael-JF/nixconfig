{ ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/core
     
    # services
    ../../modules/services/publicIp.nix
    ../../modules/services/icloudBackup
    ../../modules/services/backup.nix
    ../../modules/services/sshServer.nix
    #../../modules/services/forgejo.nix
  ];

   services.backup.devices = {
      backup = {
        device = "/dev/disk/by-label/backupUSB";
        path = "/mnt/backupUSB";
      };
      data = {
        device = "/dev/disk/by-label/backupDisk";
        path = "/data"; 
      };
  };


  services.icloudBackup.instances = {
    raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };

  system.stateVersion = "26.05";
}
