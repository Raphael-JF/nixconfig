{ pkgs, lib, config, ... }:
{
  options.services.homepage.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the homepage service.";
  };
  config = lib.mkIf config.services.homepage.enable {
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
  };
}
