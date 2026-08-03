# Backup the dataDisk partition into another drive

{ lib, config, pkgs, ... }:
{
  options.services.backup.devices = {
    
    backup = lib.types.submodule {
      options = {
        device = lib.mkOption {
          type = lib.types.str;
          description = "The backup device to store the backup";
        };
        path = lib.mkOption {
          type = lib.types.str;
          description = "The path to mount the backup device";
        };
      };
    };

    data = lib.types.submodule {
      options = {
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
  };

  config = {

    fileSystems."${config.services.backup.devices.data.path}" = {   
      device = "${config.services.backup.devices.data.device}";
      fsType = "btrfs";
      options = [
        "subvol=data"
        "compress=zstd:3"
        "noatime"
        "nofail"
      ];
    };

    fileSystems."${config.services.backup.devices.backup.path}" = {
      device = "${config.services.backup.devices.backup.device}";
      fsType = "btrfs";
      options = [
        "compress=zstd:3"
        "noatime"
        "nofail"
      ];
    };

    environment.etc."btrbk/btrbk.conf".text = ''
      snapshot_preserve_min 2d
      snapshot_preserve 14d

      target_preserve_min 2d
      target_preserve 1m

      volume ${config.services.backup.devices.data.path} {
        subvolume storage {
          snapshot_dir .snapshots
          target ${config.services.backup.devices.backup.path}
        }
      }  
    '';
    environment.systemPackages = with pkgs; [
      btrfs-progs
      gparted
      compsize
    ];

  };
}
