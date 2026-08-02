{ hostname , ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager

    ../../modules/services/icloudBackup
  ];

  packages.development.enable = true; 

  fileSystems."/run/media/${hostname}/osShared" = {
    device = "/dev/mmcblk0p4";
    fsType = "exfat";
    options = [
      "x-gvfs-show"
      "x-gvfs-name=osShared"
    ];
  };


  services.icloudBackup.instances = {
    raph = {
      appleID = "poweraphael2@gmail.com";
      directory = "/home/raph/Photos";
    };
  };


  system.stateVersion = "26.05";
}
