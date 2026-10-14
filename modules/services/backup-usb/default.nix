{ lib, config, pkgs, ... }:
{
  imports = [
    ./script.nix
  ];
  options.services."backup-usb".enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the backup service";
  };

  options.services."backup-usb".devices = {
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

  config = lib.mkIf config.services."backup-usb".enable {
    # LUKS password from sopsNix
    sops.secrets."backup-usb-key" = {
      sopsFile = ./../../secrets/backup-usb.key.enc;
      format = "binary";
      owner = "root";
      mode = "0400";
    };

    environment.systemPackages = with pkgs; [
      btrfs-progs
      btrbk
      parted
      compsize
      cryptsetup
    ];

    environment.etc."btrbk/btrbk.conf".text = ''
      snapshot_preserve_min 1d
      snapshot_preserve 7d

      target_preserve_min 2d
      target_preserve 1m

      volume ${config.services."backup-usb".devices.data.path}
        subvolume .
          snapshot_dir .snapshots
          target ${config.services."backup-usb".devices.backup.path}
    '';
  };
}
