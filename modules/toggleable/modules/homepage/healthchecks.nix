{ config, lib, globals, ... }:
let 
  port = globals.server.ports.healthchecks;
in 
{

  sops.secrets = {
    "healthchecks-secret-key" = {
        restartUnits = [ "healthchecks.service" ];
        key = "healthchecks-secret-key";
        owner = "healthchecks";
        group = "healthchecks";
    };

    "healthchecks-api-key" = {};
    "healthchecks-uuid-raph" = {};
    "healthchecks-uuid-valerie" = {};
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
