{ hostname , ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager
  ];

  packages.development.enable = true; 

  fileSystems."/run/media/${hostname}/osShared" = {
    device = "/dev/disk/by-uuid/60AC-58F9";
    fsType = "exfat";
    options = [
      "x-gvfs-show"
      "x-gvfs-name=osShared"
    ];
  };
  system.stateVersion = "26.05";
}
