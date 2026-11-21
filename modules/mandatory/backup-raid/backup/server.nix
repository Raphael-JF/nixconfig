{ config, pkgs, globals, ... }:

let
  desktopIP = globals.desktop.ip;

  backupJob = pkgs.writeShellApplication {
    name = "server-btrbk-job";

    runtimeInputs = with pkgs; [
      openssh
      coreutils
      systemd
    ];

    text = ''
      if [[ $EUID -ne 0 ]]; then
        echo "Run as root." >&2
        exit 1
      fi

      DESKTOP="${desktopIP}"
      SSH_KEY="/home/raph/.ssh/server"

      raid_started=0

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

        if (( raid_started )); then
          echo "Closing backup RAID..."

          if ! remote 'sudo -n /run/current-system/sw/bin/backup-raid-stop'; then
            echo "ERROR: Could not close RAID. Desktop stays on." >&2
            exit 1
          fi
        fi

        echo "Shutting down desktop..."
        remote 'sudo -n /run/current-system/sw/bin/poweroff' || true

        exit "$status"
      }

      echo "Booting desktop..."
      /run/current-system/sw/bin/desktop-boot

      trap cleanup EXIT

      echo "Opening backup RAID..."
      raid_started=1
      remote 'sudo -n /run/current-system/sw/bin/backup-raid-start'

      echo "Running btrbk..."
      systemctl start btrbk-desktop.service

      echo "Backup completed."
    '';
  };
in
{
  sops.secrets.btrbk-ssh-key = {
    sopsFile = ../../secrets/ssh-keys-client.yaml;
    key = "ssh-client-key";
    owner = "btrbk";
    group = "btrbk";
    mode = "0400";
  };
  services.btrbk.instances.desktop = {
    onCalendar = null;

    settings = {
      ssh_user = "btrbk";
      ssh_identity = config.sops.secrets.btrbk-ssh-key.path;
      backend_remote = "btrfs-progs-sudo";

      snapshot_preserve_min = "2d";
      snapshot_preserve = "7d";

      target_preserve_min = "latest";
      target_preserve = "7d";

      volume."/data" = {
        snapshot_dir = ".snapshots";

        subvolume."." = {
          snapshot_name = "data";
          target = "ssh://${desktopIP}/backup/server-data";
        };
      };
    };
  };

  systemd.services.server-btrbk = {
    description = "Backup /data to desktop RAID1";

    requires = [ "data.mount" ];
    after = [ "data.mount" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${backupJob}/bin/server-btrbk-job";
      TimeoutStartSec = "infinity";
    };
  };

  systemd.timers.server-btrbk = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 05:00:00";
      Persistent = true;
      Unit = "server-btrbk.service";
    };
  };
}
