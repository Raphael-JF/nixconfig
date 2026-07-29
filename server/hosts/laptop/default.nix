{ config }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/desktop
  ];
  
  config.gnome.enable = true;


  system.stateVersion = "26.05";
}
