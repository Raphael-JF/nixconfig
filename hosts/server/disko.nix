{ lib, ... }:

{
  disko.devices = {
    disk.disk1 = {
      device = "/dev/disk/by-id/mmc-MMC128_0x6cc7968d";
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
            extraArgs = [ "-L" "backupDisk" ];

            mountpoint = "/data";

            mountOptions = [
              "compress=zstd:3"
              "noatime"
            ];
          };
        };
      };
    };

    # disk.backupUSB = {
    #   device = "/dev/disk/by-id/usb-SMI_USB_DISK_KT202000000000001037-0:0";
    #   type = "disk";
    #
    #   content = {
    #     type = "gpt";
    #
    #     partitions = {
    #       backup = {
    #         size = "100%";
    #
    #         content = {
    #           type = "luks";
    #           name = "backupUSB";
    #
    #           content = {
    #             type = "btrfs";
    #             extraArgs = [ "-L" "backupUSB" ];
    #
    #             # mountpoint = "/mnt/backupUSB";
    #
    #
    #             mountOptions = [
    #               "compress=zstd:9"
    #               "noatime"
    #               "nofail"
    #             ];
    #           };
    #         };
    #       };
    #     };
    #   };
    # };
  };
}
