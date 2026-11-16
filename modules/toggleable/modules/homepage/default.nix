{ pkgs, globals, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "raphaeljontef@hotmail.com"; # <- remplace par ton vrai email
  };

  services.nginx = {
    enable = true;
    virtualHosts."${globals.server-url}" = {
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
