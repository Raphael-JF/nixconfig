{ config, globals, ... }:
let 
  port = globals.server.ports.healthchecks;
in 
{
  sops.secrets."healthchecks-secret-key" = {
    restartUnits = [ "healthchecks.service" ];
    key = "healthchecks-secret-key";
    owner = "healthchecks";
    group = "healthchecks";
  };

  sops.secrets."healthchecks-api-key" = {};
  sops.secrets."healthchecks-uuid-raph" = {};

  sops.templates."homepage.env" = {
    path = "/etc/healthchecks/homepage.env";
    content = ''
      HOMEPAGE_VAR_HEALTHCHECKS_API_KEY=${config.sops.placeholder."healthchecks-api-key"}
    '';
    restartUnits = [ "homepage-dashboard.service" ];
  };

  sops.templates."raph.env" = {
    path = "/etc/healthchecks/raph.env";
    content = ''
      HOMEPAGE_VAR_HC_raph=${config.sops.placeholder."healthchecks-uuid-raph"}
    '';
    restartUnits = [ "homepage-dashboard.service" ];
  };

  services.healthchecks = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = port;
    settings = {
      SITE_ROOT = "http://127.0.0.1:${toString port}";
      ALLOWED_HOSTS = [ "127.0.0.1" ];
      SECRET_KEY_FILE = config.sops.secrets."healthchecks-secret-key".path;
    };
  };
}
