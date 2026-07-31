# This will create a systemd.services."icloud-backup-${name}" for each instance of a given name, and a given apple id
{ pkgs, lib, config, ... }:
{
  systemd.services =
    lib.mapAttrs' # Map on configured instances and associate each instance with a systemd service 
      (name: cfg: lib.nameValuePair
        ("icloudBackup-${name}")
        (
          {
            description = "iCloud backup for ${name}";

            serviceConfig = {
              Type = "oneshot";
              User = "icloudBackupUser-${name}";
            };

            stateDir = "/var/lib/icloudBackup/${name}";

            script = ''
              ${pkgs.icloudpd}/bin/icloudpd \
                --directory ${cfg.directory} \
                --folder-structure "{:%Y/%m}" \
                --username ${cfg.appleID}\
                --cookie-directory /var/lib/icloudBackup/${name}/cookies \
            '';
          }
        )
      )
      (config.services.icloudBackup.instances);
  # Map on configured instances and associate each instance with a systemd timer

  systemd.timers = 
    lib.mapAttrs' (name: cfg: lib.nameValuePair
      ("icloud-backup-${name}")
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
    (config.services.icloudBackup.instances);
 
}
