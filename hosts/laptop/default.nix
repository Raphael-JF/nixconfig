{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core

    ../../modules/dev
    ../../modules/windowManager
    ../../modules/services/sshServer.nix
    # ../../modules/services/airplay.nix
  ];
  services.sshServer.enable = true;
  packages.development.enable = true; 

  fileSystems."/run/media/raph/osShared" = {
    device = "/dev/disk/by-uuid/726D-7F83";
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

  # run kitty at startup
    environment.etc."xdg/autostart/kitty.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Kitty
      Exec=${pkgs.kitty}/bin/kitty
      X-GNOME-Autostart-enabled=true
    '';

  system.stateVersion = "26.05";

}
