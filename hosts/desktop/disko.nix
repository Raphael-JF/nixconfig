{ lib, ... }:

{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/sda";
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

          osShared = {
            name = "osShared";
            size = "200G"; # à adapter
            type = "0700";

            content = {
              type = "filesystem";
              format = "exfat";
              mountpoint = "/run/media/raph/osShared";

              mountOptions = [
                "nofail"
                "noatime"
              ];
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
          size = "16G";

          content = {
            type = "swap";
            randomEncryption = true;
          };
        };

        root = {
          size = "100%FREE";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
