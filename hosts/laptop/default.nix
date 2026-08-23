{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager
    ../../modules/services/sshServer.nix
  ];
  services.sshServer.enable = true;
  packages.development.enable = true; 

  fileSystems."/run/media/raph/osShared" = {
    device = "/dev/disk/by-uuid/FBFB-E12E";
    fsType = "exfat";
    options = [
      "x-gvfs-show"
      "x-gvfs-name=osShared"
      "nofail"
      "noatime"
      "uid=1000"
      "gid=100"
      "umask=000"
    ];
  }; 
  boot.kernelParams = [
    "mem_sleep_default=s2idle"
  ];

  system.stateVersion = "26.05";

}
