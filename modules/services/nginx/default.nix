{ config, pkgs, ... }:
{

  security.acme = {
    acceptTerms = true;
    defaults.email = "raphaeljontef@hotmail.com"; # <- remplace par ton vrai email
  };

  services.nginx = {
    enable = true;
    virtualHosts."82.126.172.121.nip.io" = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.writeTextDir "index.html"
        (builtins.readFile ./index.html);
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
