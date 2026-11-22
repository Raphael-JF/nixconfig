{ config, lib, globals, ... }:

let
  icloud = config.services.icloudBackup;
in
{
  services.homepage-dashboard.services = lib.mkIf (icloud.enable) [
    {
      "Sauvegardes iCloud" = lib.mapAttrsToList (name: _: {
        ${name} = {
          icon = "mdi-camera";
          widget = {
            type = "healthchecks";
            url = "http://127.0.0.1:${toString globals.server.ports.healthchecks}";
            key = "{{HOMEPAGE_VAR_HEALTHCHECKS_API_KEY}}";
            uuid = "{{HOMEPAGE_VAR_HEALTHCHECKS_${name}}}";
          };
        };
      }) icloud.instances;
    }
  ];
}
