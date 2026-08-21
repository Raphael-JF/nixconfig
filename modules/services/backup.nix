{ lib, config, pkgs, ... }:

let
  backup = config.services.backup.devices.backup;
  data = config.services.backup.devices.data;
  mount-backupUSB = pkgs.writeShellScriptBin "mount-backupUSB" ''
    set -euo pipefail

    LUKS_NAME="backupUSB"
    LUKS_DEVICE="${backup.device}"
    MOUNTPOINT="${backup.path}"
    LUKS_MAPPER="/dev/mapper/$LUKS_NAME"
    LUKS_KEY="${config.sops.secrets."backupUSB-key".path}"

    echo "Opening LUKS device..."
    ${pkgs.cryptsetup}/bin/cryptsetup open \
      --key-file "$LUKS_KEY" \
      "$LUKS_DEVICE" \
      "$LUKS_NAME"

    echo "Mounting backup filesystem..."
    mkdir -p "$MOUNTPOINT"
    ${pkgs.util-linux}/bin/mount "$LUKS_MAPPER" "$MOUNTPOINT"

    echo "Backup filesystem mounted at $MOUNTPOINT"
  '';

  umount-backupUSB = pkgs.writeShellScriptBin "umount-backupUSB" ''
    set -euo pipefail

    LUKS_NAME="backupUSB"
    MOUNTPOINT="${backup.path}"

    echo "Unmounting backup filesystem..."
    ${pkgs.util-linux}/bin/umount "$MOUNTPOINT"

    echo "Closing LUKS device..."
    ${pkgs.cryptsetup}/bin/cryptsetup close "$LUKS_NAME"

    echo "Backup USB closed."
  '';

  backupScript = pkgs.writeShellScript "backup-backupUSB" ''
    set -euo pipefail

    trap 'umount-backupUSB' EXIT

    mount-backupUSB

    echo "Starting btrbk backup..."
    ${pkgs.btrbk}/bin/btrbk run

    echo "Backup completed successfully."
  '';
in
{
  options.services.backup.devices = {
    backup = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "The LUKS device used for backups";
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = "The path where the backup filesystem is mounted";
      };
    };

    data = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "The device containing the data";
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = "The path where the data filesystem is mounted";
      };
    };
  };

  config = {
    # LUKS password from sops-nix
    sops.secrets."backupUSB-key" = {
      sopsFile = ./../../secrets/backupUSB.key.enc;
      format = "binary";
      owner = "root";
      mode = "0400";
    };

    environment.systemPackages = with pkgs; [
      btrfs-progs
      btrbk
      gparted
      parted
      compsize
      cryptsetup
      mount-backupUSB
      umount-backupUSB
    ];

    environment.etc."btrbk/btrbk.conf".text = ''
      snapshot_preserve_min 2d
      snapshot_preserve 14d

      target_preserve_min 2d
      target_preserve 1m

      volume ${data.path}
        subvolume .
          snapshot_dir .snapshots
          target ${backup.path}
    '';

    systemd.services.btrbk-backup-data = {
      description = "Backup Btrfs data to encrypted USB";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = backupScript;
        User = "root";
      };
    };

    systemd.timers.btrbk-backup-data = {
      description = "Timer for Btrfs backup to encrypted USB";

      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "*-*-* 05:00:00";
        Persistent = true;
      };
    };
  };
}
