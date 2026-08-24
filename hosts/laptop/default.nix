{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/windowManager
    ../../modules/services/sshServer.nix
    ../../modules/services/airplay.nix
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

  # Open network ports
  networking.firewall.allowedTCPPorts = [ 7000 7001 7100 ];
  networking.firewall.allowedUDPPorts = [ 5353 6000 6001 7011 ];

  # To enable network-discovery
  services.avahi = {
    enable = true;
    nssmdns = true;  # printing
    openFirewall = true; # ensuring that firewall ports are open as needed
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
      domain = true;
    };
  };

  environment.systemPackages = with pkgs; [
    uxplay
  ];


  system.stateVersion = "26.05";

}
