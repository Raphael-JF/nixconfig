{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."_" = {
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
        }
      ];
      root = pkgs.writeTextDir "index.html" (builtins.readFile ./index.html);
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
  ];
}
