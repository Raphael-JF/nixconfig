{ ... }:

{
  imports = [
    ../../modules/networking.nix
    ../../modules/users.nix
    ../../modules/packages.nix
    ../../modules/security.nix
    ../../modules/firewall.nix
    ../../modules/ssh.nix
  ];

  system.stateVersion = "26.05";
}
