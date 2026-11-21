{ pkgs, globals, ... }:

let
  desktopIP = globals.desktop.ip;
in
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "desktop-backup";

      runtimeInputs = with pkgs; [
        openssh
        rsync
        coreutils
      ];

      text = ''
        if [[ $EUID -ne 0 ]]; then
          echo "Run as root." >&2
          exit 1
        fi

        DESKTOP="${desktopIP}"
        SSH_KEY="/home/raph/.ssh/server"

        raid_open=0

        remote() {
          ssh \
            -i "$SSH_KEY" \
            -o BatchMode=yes \
            -o StrictHostKeyChecking=yes \
            -o ConnectTimeout=10 \
            raph@"$DESKTOP" "$@"
        }

        cleanup() {
          status=$?
          trap - EXIT

          if (( raid_open )); then
            echo "Closing backup RAID..."

            if ! remote 'sudo -n /run/current-system/sw/bin/backup-raid-stop'; then
              echo "ERROR: Could not close RAID. Desktop stays on." >&2
              exit 1
            fi
          fi

          echo "Shutting down desktop..."

          if ! remote 'sudo -n /run/current-system/sw/bin/poweroff'; then
            echo "WARNING: Could not shut down desktop." >&2
            exit 1
          fi

          exit "$status"
        }

        echo "Booting and unlocking desktop..."
        desktop-boot

        trap cleanup EXIT

        echo "Opening backup RAID..."
        remote 'sudo -n /run/current-system/sw/bin/backup-raid-start'

        raid_open=1

        echo "Backing up /data..."

        rsync \
          -aHAX \
          --numeric-ids \
          --info=progress2 \
          --partial \
          --rsync-path="sudo -n rsync" \
          -e "ssh -i $SSH_KEY -o BatchMode=yes -o StrictHostKeyChecking=yes" \
          /data/ \
          "raph@$DESKTOP:/backup/data/"

        echo "Backup completed successfully."
      '';
    })
  ];
}
