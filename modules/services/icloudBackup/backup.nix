{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.services.icloudBackup.enable {
    
    systemd.tmpfiles.rules =
      lib.mapAttrsToList
      (name: cfg:
        "d ${cfg.savePath} 2770 icloudSystemUser-${name} icloudPhotos -"
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
                Type = "oneshot";
                User = "icloudSystemUser-${name}";
                UMask = "0007";
              };
              script = ''
                ${pkgs.icloudpd}/bin/icloudpd \
                  --directory ${cfg.savePath} \
                  --folder-structure "{:%Y/%m}" \
                  --username ${cfg.appleID}\
                  --cookie-directory ~/cookies \
              '';
              unitConfig = lib.mkIf config.services.raphNextcloud.enable {
                OnSuccess = "nextcloudUpdateCache.service";
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
