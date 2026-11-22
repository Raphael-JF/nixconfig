{ config, lib, ... }:

let
  icloud = config.services.icloudBackup;
in
{
  services.homepage-dashboard.services =
    lib.mkIf (icloud.enable) [
      {
        "Sauvegardes iCloud" = lib.mapAttrsToList (name: profile: {
          ${name} = {
            icon = "mdi-camera";
            widget = {
              type = "healthchecks";
              url = "http://127.0.0.1:8000";
              key = "{{HOMEPAGE_VAR_HEALTHCHECKS_API_KEY}}";
              uuid = profile.healthchecksUuid;
            };
          };
        }) icloud.instances;
      }
    ];
}
