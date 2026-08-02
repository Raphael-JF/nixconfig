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
          sudo chown raph:users "$COOKIE_DIR"

          
          ${pkgs.icloudpd}/bin/icloudpd  \
          --auth-only \
          --username ${cfg.appleID} \
          --cookie-directory $COOKIE_DIR \
          --password-provider console
          echo "Fixing permissions..."

          sudo chown -R icloudSystemUser-${name}:icloudSystemUser-${name} "$COOKIE_DIR"
          sudo chmod -R go-rwx "$COOKIE_DIR"

          echo "Done."
        '';
      }
    )
    config.services.icloudBackup.instances; 
}
