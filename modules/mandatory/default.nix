{ ... }:
{
  imports = [
    ./bash.nix
    ./boot.nix  
    ./locale.nix
    ./nix.nix
    ./networking.nix
    ./packages.nix
    ./raphUser.nix
    ./security.nix
    ./ssh-client.nix
    ./ssh-server.nix
    ./git.nix
    ./nvim.nix
    ./windowManager
    ./remote-boot
    ./wireguard
  ];
}
