{ pkgs, lib, config, ... }:

{
  config = (
    lib.mapAttrsToList
      (name: cfg:
        {
          systemd.tmpfiles.rules = [
            "d /data/nextcloud/data/raph/files/Photos 2770 icloudSystemUser-${name} icloudPhotos -"
          ];
          systemd.services."icloudBackup-${name}" = {
            description = "iCloud backup for ${name}";

            serviceConfig = {
              Type = "oneshot";
              User = "icloudSystemUser-${name}";
              UMask = "0007";
            };

            script = ''
              ${pkgs.icloudpd}/bin/icloudpd \
                --directory ${cfg.savePath} \
                --folder-structure "{:%Y/%m}" \
                --username ${cfg.appleID} \
                --cookie-directory ~/cookies \
            '';

            unitConfig = {
              OnSuccess = "nextcloud-update-cache.service";
            };
          };

          systemd.timers."icloudBackup-${name}" = {
            description = "Timer for iCloud backup for ${name}";

            timerConfig = {
              OnCalendar = "*-*-* 03:00:00";
              Persistent = true;
            };

            wantedBy = [ "timers.target" ];
          };
        }
      )
      config.services.icloudBackup.instances
  );
}
