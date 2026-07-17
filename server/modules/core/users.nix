{ ... }:

{
  users.users.raph = {
    initialPassword = "a";
    isNormalUser = true;

    extraGroups = [
      "wheel"
      "docker"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+mpQTHhucCVywM74pja3n+oLvEbN3Rh6Kdr0ogjjy2 raph@raph-desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIESTCleHAfmgUQfFz0Rp3xtKmgDzowuKmRiwE6m6H6RA raph@raph-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjPNDWi4vjiqAp+MdByvlIEhKsr/TDOLQVGq4UQSiEm mobile@iPhone"
 
    ];

  };

}
