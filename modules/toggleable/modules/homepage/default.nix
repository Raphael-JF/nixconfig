{ config, globals, lib, pkgs, ... }:

let
  port = globals.server.ports.homepage;
  authPort = globals.server.ports.homepage-auth;
  authBackend = "http://127.0.0.1:${toString authPort}";
  python = pkgs.python3.withPackages (ps: with ps; [ argon2-cffi flask waitress ]);
in
{
  imports  = [
    ./config-services
    ./healthchecks.nix
  ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "raphaeljontef@hotmail.com";
  };

  sops.secrets.homepage-password = {
    restartUnits = [ "homepage-auth.service" ];
    key = "homepage-password";
  };

  services.homepage-dashboard = {
    enable = true;
    listenPort = port;
    openFirewall = false;
    allowedHosts = globals.server-url;

    settings = {
      title = "Raph's Server";
      language = "fr";
      theme = "dark";
    };

    bookmarks = [
      {
        Compte = [
          {
            "Se déconnecter" = [ { href = "https://${globals.server-url}/logout"; } ];
          }
        ];
      }
    ];
    
  };

  systemd.services.homepage-dashboard = {
    environment.HOSTNAME = "127.0.0.1";
  };

  systemd.services.homepage-auth = {
    description = "Homepage login and sessions";
    wantedBy = [ "multi-user.target" ];
    after = [ "sops-install-secrets.service" ];
    environment.HOMEPAGE_PUBLIC_HOST = globals.server-url;
    environment.HOMEPAGE_AUTH_PORT = toString authPort;
    serviceConfig = {
      ExecStart = "${python}/bin/python ${./homepage_auth.py}";
      LoadCredential = "password-hash:${config.sops.secrets.homepage-password.path}";
      StateDirectory = "homepage-auth";
      StateDirectoryMode = "0700";
      DynamicUser = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      Restart = "on-failure";
    };
  };

  services.nginx = {
    enable = true;
    appendHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=homepage_login:1m rate=5r/m;
    '';
    virtualHosts."${globals.server-url}" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          recommendedProxySettings = true;
          extraConfig = ''
            auth_request /_homepage_session;
            error_page 401 = @homepage_login;
            proxy_set_header Authorization "";
            proxy_set_header Cookie "";
            add_header Cache-Control "private, no-store" always;
          '';
        };

        "= /_homepage_session" = {
          proxyPass = "${authBackend}/verify";
          recommendedProxySettings = true;
          extraConfig = ''
            internal;
            proxy_method GET;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
          '';
        };

        "= /login" = {
          proxyPass = "${authBackend}/login";
          recommendedProxySettings = true;
          extraConfig = ''
            client_max_body_size 4k;
            limit_req zone=homepage_login burst=5 nodelay;
            limit_req_status 429;
          '';
        };

        "= /logout" = {
          proxyPass = "${authBackend}/logout";
          recommendedProxySettings = true;
          extraConfig = "client_max_body_size 4k;";
        };

        "@homepage_login".return = "302 /login";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    globals.server.ports.http 
    globals.server.ports.https
  ];

  sops.templates."homepage.env" = {
    path = "/etc/homepage-dashboard/homepage.env";
    owner = "root";
    group = "root";
    mode = "0400";
    content = ''
      HOMEPAGE_VAR_HEALTHCHECKS_API_KEY=${config.sops.placeholder."healthchecks-api-key"}
      HOMEPAGE_VAR_HEALTHCHECKS_raph=${config.sops.placeholder."healthchecks-uuid-raph"}
      HOMEPAGE_VAR_HEALTHCHECKS_valerie=${config.sops.placeholder."healthchecks-uuid-valerie"}
      NEXTCLOUD_PASSWORD=${config.sops.placeholder."nextcloud-password"}
    '';
    restartUnits = [ "homepage-dashboard.service" ];
  };

  systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile = (
    [ "/etc/homepage-dashboard/homepage.env" ]
  );
}
