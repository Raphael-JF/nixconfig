{ pkgs, config, ...}:
let 
  backup = config.services.backup.devices.backup;
  mount = pkgs.writeShellScriptBin "mount-backup-usb" ''
    set -euo pipefail

    LUKS_NAME="backupUSB"
    LUKS_DEVICE="${backup.device}"
    LUKS_MAPPER="/dev/mapper/$LUKS_NAME"
    LUKS_KEY="${config.sops.secrets."backup-usb-key".path}"

    echo "Opening LUKS device..."
    ${pkgs.cryptsetup}/bin/cryptsetup open \
      --key-file "$LUKS_KEY" \
      '${backup.device}' \
      "$LUKS_NAME"

    echo "Mounting backup filesystem..."
    mkdir -p '${backup.path}'
    ${pkgs.util-linux}/bin/mount "$LUKS_MAPPER" '${backup.path}'
  '';
  umount = pkgs.writeShellScriptBin "umount-backup-usb" ''
    set -euo pipefail

    LUKS_NAME="backupUSB"

    echo "Unmounting backup filesystem..."
    ${pkgs.util-linux}/bin/umount '${backup.path}'

    echo "Closing LUKS device..."
    ${pkgs.cryptsetup}/bin/cryptsetup close "$LUKS_NAME"
  '';

  backupScript = pkgs.writeShellScript "backup-backup-usb" ''
    set -euo pipefail

    trap '${umount}/bin/umount-backup-usb' EXIT

    ${mount}/bin/mount-backup-usb

    echo "Starting btrbk backup..."
    ${pkgs.btrbk}/bin/btrbk run

    echo "Backup completed successfully."
  '';
in
{
  environment.systemPackages = 
  [
    mount 
    umount
    backupScript
  ];

  systemd.services."backup-usb" = {
    description = "Backup Btrfs data to encrypted USB";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = backupScript;
      User = "root";
    };
  };

  systemd.timers."backup-usb" = {
    description = "Timer for Btrfs backup to encrypted USB";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 05:00:00";
      Persistent = true;
    };
  };
}
