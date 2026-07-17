{ ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/core/boot.nix
    ../../modules/core/nix.nix
    ../../modules/core/networking.nix
    ../../modules/core/locale.nix
    ../../modules/core/packages.nix
    ../../modules/core/security.nix
    ../../modules/core/firewall.nix
    ../../modules/core/users.nix
    ../../modules/core/ssh.nix
    ../../modules/core/bash.nix

    # services
    ../../modules/services/docker.nix
  ];

  system.stateVersion = "26.05";
}
