# This will create a "icloudAuth-${name}" login program for each instance of a given name, and a given apple id
{ pkgs, lib, config, ... }:
{
  environment.systemPackages =
  lib.mapAttrsToList
    (name: cfg:
      pkgs.writeShellApplication {
        name = "icloudAuth-${name}";

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

          sudo chown -R icloudSystemUser-${name}:icloudSystemUser-${name} "$COOKIE_DIR"
          sudo chmod -R go-rwx "$COOKIE_DIR"

          echo "Done."
        '';
      }
    )
    config.services.icloudBackup.instances;

  systemd.timers = 
    lib.mapAttrs' (name: cfg: lib.nameValuePair
      ("icloudAuth-${name}")
      (
        {
          description = "Timer for iCloud authentication for ${name}";

          timerConfig = {
            OnCalendar = "*-*-01 03:00:00"; # Run on the first day of every month at 3 AM
            Persistent = true; # Run the job immediately if it was missed (e.g., if the computer was off)
          };

          wantedBy = [ "timers.target" ];
        }
      )
    )
    (config.services.icloudBackup.instances);
 
}
