
{ config, ... }:

{
  users.users.raph = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.raphPassword.path;

    extraGroups = [
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjPNDWi4vjiqAp+MdByvlIEhKsr/TDOLQVGq4UQSiEm mobile@iPhone"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+mpQTHhucCVywM74pja3n+oLvEbN3Rh6Kdr0ogjjy2 raph@raph-desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESTCleHAfmgUQfFz0Rp3xtKmgDzowuKmRiwE6m6H6RA raph@raph-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaba6PCu89ZE4P3XwwoPtv/ngl6druZ+oswSOphVHxJ raph@raph-server"
    ];
  };

}
