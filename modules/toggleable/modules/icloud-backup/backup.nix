{ pkgs, lib, config, globals, ... }:
{
  config = lib.mkIf config.services.icloudBackup.enable {
    
    systemd.tmpfiles.rules =
      lib.mapAttrsToList
      (name: cfg:
        "d ${cfg.savePath} 2770 icloudSystemUser-${name} icloudPhotos -"
        "a+ /data/nextcloud/data - - - - u:icloudSystemUser-${name}:--x"
      )
      config.services.icloudBackup.instances;

    systemd.services =
      lib.mapAttrs' 
      (name: cfg: lib.nameValuePair
        ("icloudBackup-${name}")
          (
            {
              description = "iCloud backup for ${name}";

              serviceConfig = {
                EnvironmentFile = "-/etc/homepage-dashboard/homepage.env";
                Type = "oneshot";
                User = "icloudSystemUser-${name}";
                UMask = "0007";
              };
              script = ''
                uuid=$(printenv ${lib.escapeShellArg "HOMEPAGE_VAR_HEALTHCHECKS_${name}"} || true)
                ping_check() {
                  if [ -n "$uuid" ]; then
                    ${pkgs.curl}/bin/curl -fsS --max-time 5 -o /dev/null "http://127.0.0.1:${toString globals.server.ports.healthchecks}/ping/$uuid/$1" || echo "Healthchecks ping failed" >&2
                  fi
                }
                ping_check start
                status=0
                ${pkgs.icloudpd}/bin/icloudpd \
                  --directory ${cfg.savePath} \
                  --folder-structure "{:%Y/%m}" \
                  --username ${cfg.appleID}\
                  --cookie-directory ~/cookies || status=$?
                ping_check "$status"
                exit "$status"
              '';
              unitConfig = {
                OnSuccess = "nextcloud-update-cache.service";
              };
            }
          )
        )
        config.services.icloudBackup.instances;

    systemd.timers = 
      lib.mapAttrs' (name: cfg: lib.nameValuePair
        ("icloudBackup-${name}")
        (
          {
            description = "Timer for iCloud backup for ${name}";

            timerConfig = {
              OnCalendar = "*-*-* 03:00:00"; # Run every day at 3 AM
              Persistent = true; # Run the job immediately if it was missed (e.g., if the computer was off)
            };

            wantedBy = [ "timers.target" ];
          }
        )
      )
      config.services.icloudBackup.instances;
  };
}
