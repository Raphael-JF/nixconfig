{ pkgs, lib, ... }:

{
  imports = [

    ./hardware-configuration.nix
    # ./disko.nix

    ../../modules
  ];
  
  services.icloudBackup = {
    enable = true;
    instances.raph = {
      savePath = "/data/nextcloud/data/raph/files/Photos";
      appleID = "poweraphael2@gmail.com";
    };
  };

  system.stateVersion = "26.05";
}
