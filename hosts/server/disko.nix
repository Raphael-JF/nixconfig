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
          size = "8G";

          content = {
            type = "swap";
            randomEncryption = true;
          };
        };

        root = {
          size = "40G";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };

        data = {
          size = "100%FREE";

          content = {
            type = "btrfs";

            subvolumes = {
              "/data" = {
                mountpoint = "/data";

                mountOptions = [
                  "compress=zstd:3"
                  "noatime"
                  "nofail"
                ];
              };
            };
          };
        };
      };
    };
  };
}
