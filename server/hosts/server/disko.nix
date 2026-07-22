{ lib, ... }:

{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/mmcblk0";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            name = "ESP";
            size = "512M";
            type = "EF00";

            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          luks = {
            name = "cryptroot";
            size = "100%";

            content = {
              type = "luks";
              name = "cryptroot";

              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg.pool = {
      type = "lvm_vg";

      lvs = {
        swap = {
          size = "8G"; # adapte selon ta RAM

          content = {
            type = "swap";
            randomEncryption = true;
          };
        };

        root = {
          size = "40G"; # ou 30G, selon tes besoins

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };

        data = {
          size = "100%FREE";

          content = {
            type = "filesystem";
            format = "btrfs";
            mountpoint = "/data";

            mountOptions = [
              "compress=zstd:6"
              "noatime"
            ];
          };
        };
      };
    };
  };
}
