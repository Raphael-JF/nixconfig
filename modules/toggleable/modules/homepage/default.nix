{ config, globals, lib, ... }:
let
  host = globals.server-url;
  port = 8082;
  credentials = ../../../../secrets/homepage-htpasswd.enc;
  hasCredentials = builtins.pathExists credentials;
in
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "raphaeljontef@hotmail.com";
  };

  sops.secrets.homepage-htpasswd = lib.mkIf hasCredentials {
    sopsFile = credentials;
    format = "binary";
    owner = config.services.nginx.user;
    restartUnits = [ "nginx.service" ];
  };

  services.homepage-dashboard = {
    enable = hasCredentials;
    listenPort = port;
    openFirewall = false;
    allowedHosts = host;

    settings = {
      title = "Raph's Server";
      language = "fr";
      theme = "dark";
    };

    services = [
      {
        Services = [
          {
            Fichiers = {
              icon = "nextcloud.png";
              href = "https://files.${host}/apps/files/files";
            };
          }
          {
            Recettes = {
              href = "https://recipiz.${host}";
              siteMonitor = "https://recipiz.${host}";
            };
          }
        ];
      }
    ];
  };

  systemd.services.homepage-dashboard = lib.mkIf hasCredentials {
    environment.HOSTNAME = "127.0.0.1";
  };

  services.nginx = {
    enable = true;
    virtualHosts."${host}" = {
      enableACME = true;
      forceSSL = true;

      basicAuthFile = if hasCredentials then config.sops.secrets.homepage-htpasswd.path else null;

      locations."/" = if hasCredentials then {
        proxyPass = "http://127.0.0.1:${toString port}";
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_set_header Authorization "";
        '';
      } else {
        return = "503";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
