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
    ./sshClient.nix
    ./git.nix
    ./nvim.nix
  ];
}
