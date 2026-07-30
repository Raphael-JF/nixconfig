{ config, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager
  ];

  packages.development.enable = true; 

  fileSystems."/mnt/osShared" = {
    device = "/dev/disk/by-uuid/60AC-58F9";
    fsType = "exfat";
    options = [ "nofail" ];
  };
  system.stateVersion = "26.05";
}
