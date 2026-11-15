{ ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22   # ssh
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = false; # We manage the firewall separately
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowAgentForwarding = false;
      AllowTcpForwarding = true;
      Macs = [
        "hmac-sha2-256"
        "hmac-sha2-512"
      ];
    };
  };

  users.users.raph.openssh.authorizedKeys.keyFiles = [
    ../../public-ssh-keys/desktop.pub
    ../../public-ssh-keys/laptop.pub
    ../../public-ssh-keys/server.pub
    ../../public-ssh-keys/iphone.pub
    ../../public-ssh-keys/enseirb.pub
  ];
}
