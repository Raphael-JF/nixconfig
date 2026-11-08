{ lib, ... }:

{
  disko.devices.disk = {
    hdd500 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-WDC_WD5000LPVX-60V0TT0_WD-WXQ1E34HUPC5";

      content = {
        type = "gpt";

        partitions = {
          osShared = {
            name = "osShared";
            size = "50G";
            content = {
              type = "filesystem";
              format = "exfat";
              mountpoint = "/run/media/raph/osShared";
              mountOptions = [
                "nofail"
                "noatime"
                "x-gvfs-show"
              ];
            };
          };

          backup = {
            name = "backup";
            size = "319G";
            content = {
              type = "luks";
              name = "backup500";
            };
          };

          windows = {
            name = "Windows";
            size = "100%";
            type = "0700";
          };
        };
      };
      };

      hdd320 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Hitachi_HDT725032VLA360_VFK201R811U83X";

      content = {
        type = "gpt";

        partitions = {
          backup = {
            name = "backup";
            size = "100%";
            content = {
              type = "luks";
              name = "backup320";
            };
          };
        };
      };
    };
  };
}
