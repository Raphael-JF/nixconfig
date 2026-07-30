{ config, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/desktop
  ];

  packages.development.enable = true; 
  system.stateVersion = "26.05";
}
