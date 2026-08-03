{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager

    ../../modules/services/icloudBackup
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

  fileSystems."/mnt/backupDisk" = {
    device = "/dev/disk/by-label/backupDisk";
    fsType = "btrfs";
    options = [ "compress=zstd:3" "noatime" "nofail"];
  };

  environment.systemPackages = with pkgs; [
    btrfs-progs
    gparted
    compsize
  ];

  services.icloudBackup.instances = {
    raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };


  system.stateVersion = "26.05";
}
