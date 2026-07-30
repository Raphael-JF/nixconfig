{ pkgs, lib, config, ... }:
{
  # TODO : way to alert when the cookie is expired and the backup fails. Maybe via a splash alert when the user logs in 
  options.services.icloudBackup = {
    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {

          appleID = lib.mkOption {
            type = lib.types.str;
            description = "Apple ID";
          };

          directory = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/icloud-backup";
            description = "Backup directory";
          };

        };
      });

      default = {};
    };
  };

  config = {
    users.groups =
      lib.mapAttrs' # Map on configured instances and associate each instance with a system group
        (name: cfg: lib.nameValuePair
          ("icloudBackup")
          (
            {
              isSystemGroup = true;
            }
          )
        )
        (config.services.icloudBackup.instances);

    users.users = 
      lib.mapAttrs' # Map on configured instances and associate each instance with a system user
        (name: cfg: lib.nameValuePair
          ("icloudBackupUser-${name}")
          (
            {
              isSystemUser = true;
              group = "icloudBackup";
              home = "/var/lib/icloudBackup/${name}";
              createHome = true;
            }
          )
        )
        (config.services.icloudBackup.instances);

    # This will create a systemd.services."icloud-backup-${name}" for each instance of a given name, and a given apple id
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

              stateDir = "/var/lib/icloud-backup";

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
  

  environment.systemPackages =
  lib.mapAttrsToList
    (name: cfg:
      pkgs.writeShellApplication {
        name = "icloudBackup-cookie-${name}";

        runtimeInputs = [
          pkgs.icloudpd
        ];

        text = ''
          set -euo pipefail

          COOKIE_DIR="/var/lib/icloudBackup/${name}/cookies"

          echo "Creating iCloud cookie for instance: ${name}"
          echo "Cookie directory: $COOKIE_DIR"

          sudo mkdir -p "$COOKIE_DIR"
          sudo chown raph:raph "$COOKIE_DIR"

          ${pkgs.icloudpd}/bin/icloudpd \
            --username "${cfg.appleID}" \
            --cookie-directory "$COOKIE_DIR"

          echo "Fixing permissions..."

          sudo chown -R icloudBackupUser-${name}:icloudBackup "$COOKIE_DIR"
          sudo chmod -R go-rwx "$COOKIE_DIR"

          echo "Done."
        '';
      }
    )
    config.services.icloudBackup.instances;
  };
}
