{
  networking.firewall = {

    enable = true;

    allowedTCPPorts = [
      22   # ssh
      3000 # forgejo
      2222 # forgejo
    ];
  };
}
