{ ... }:
{
  imports = [
    ./bash.nix
    ./locale.nix
    ./nix.nix
    ./boot.nix 
    ./networking.nix
    ./packages.nix
    ./raphUser.nix
    ./security.nix
    ./ssh-client.nix
    ./ssh-server.nix
    ./git.nix
    ./nvim.nix
    ./dev
  ];
}
