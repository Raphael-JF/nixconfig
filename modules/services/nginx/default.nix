{ config, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    virtualHosts."_" = {
      listen = [{
        addr = "0.0.0.0";
        port = 80;
      }];

      extraConfig = ''
        return 301 https://$host$request_uri;
      '';
    };

    virtualHosts."https" = {
      listen = [{
        addr = "0.0.0.0";
        port = 443;
        ssl = true;
      }];

      sslCertificate = "/var/lib/nginx/certs/server.crt";
      sslCertificateKey = "/var/lib/nginx/certs/server.key";

      root = pkgs.writeTextDir "index.html"
        (builtins.readFile ./index.html);
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
