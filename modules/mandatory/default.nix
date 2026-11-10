{ ... }:
{
  imports = [
    ./bash.nix
    ./boot.nix  
    ./locale.nix
    ./nix.nix
    ./networking.nix
    ./packages.nix
    ./raph-user.nix
    ./security.nix
    ./ssh-client.nix
    ./ssh-server.nix
    ./git.nix
    ./nvim.nix
    ./windows-manager
    ./remote-boot
    ./wireguard
  ];
}
