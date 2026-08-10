# Backup the data partition into another drive

{ lib, config, pkgs, ... }:
{

  options.services.backup.devices = {
    
    backup = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "The backup device to store the backup";
      };
      path = lib.mkOption {
        type = lib.types.str;
        description = "The path to mount the backup device";
      };
    };

    data = {
      device = lib.mkOption {
        type = lib.types.str;
        description = "The device to store the data";
      };
      path = lib.mkOption {
        type = lib.types.str;
        description = "The path to mount the data device";
      };
    };
  };

  config = {

    environment.systemPackages = with pkgs; [
      btrfs-progs
      gparted
      parted
      compsize
    ];

    environment.etc."btrbk/btrbk.conf".text = ''
      snapshot_preserve_min 2d
      snapshot_preserve 14d

      target_preserve_min 2d
      target_preserve 1m

      volume ${config.services.backup.devices.data.path} 
        subvolume . 
          snapshot_dir .snapshots
          target ${config.services.backup.devices.backup.path}
    '';

    systemd.services."btrbk-backup-data" = {
      description = "Backup Btrfs data to USB key";

      # ensure that the backup device is mounted before running the service
      unitConfig = {
        RequiresMountsFor = [ config.services.backup.devices.backup.path ];
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.btrbk}/bin/btrbk run";
        User = "root";
      };
    };

    systemd.timers."btrbk-backup-data" = {
      description = "Timer pour le backup Btrfs vers la clé USB";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 05:00:00";
        Persistent = true;        
      };
    };
  };
}
