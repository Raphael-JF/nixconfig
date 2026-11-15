{ pkgs, ... }:
{
  security.sudo.wheelNeedsPassword = true;

  environment.systemPackages = with pkgs; [
    sops
    age
  ];

  sops = {
    useSystemdActivation = true;

    defaultSopsFile = ../../secrets/passwords.yaml;
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
