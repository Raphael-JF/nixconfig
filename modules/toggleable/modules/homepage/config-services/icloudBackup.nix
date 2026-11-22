{ config, lib, globals, ... }:

let
  icloud = config.services.icloudBackup;
in
{
  systemd.services.homepage-dashboard.serviceConfig.EnvironmentFile = lib.mkIf icloud.enable (
    [ "-/etc/healthchecks/homepage.env" ]
    ++ map (name: "-/etc/healthchecks/${name}.env") (builtins.attrNames icloud.instances)
  );

  services.homepage-dashboard.services =
    lib.mkIf (icloud.enable) [
      {
        "Sauvegardes iCloud" = lib.mapAttrsToList (name: _: {
          ${name} = {
            icon = "mdi-camera";
            widget = {
              type = "healthchecks";
              url = "http://127.0.0.1:${toString globals.server.ports.checkhealth}";
              key = "{{HOMEPAGE_VAR_HEALTHCHECKS_API_KEY}}";
              uuid = "{{HOMEPAGE_VAR_HC_${name}}}";
            };
          };
        }) icloud.instances;
      }
    ];
}
