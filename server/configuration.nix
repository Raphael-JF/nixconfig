{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  users.users.raph = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "a";
 };
  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    # change this to your ssh key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+mpQTHhucCVywM74pja3n+oLvEbN3Rh6Kdr0ogjjy2 raph@raph-desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESTCleHAfmgUQfFz0Rp3xtKmgDzowuKmRiwE6m6H6RA raph@raph-laptop"

  ];
  system.stateVersion = "24.05";
}
