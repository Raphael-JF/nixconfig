{ config, lib, ...}:
{
  options = {
    windowManager.osShared.device = lib.mkOption {
      type = lib.types.str;
      description = "Path to the shared OS partition.";
    };
  };
  config = {
    fileSystems."/run/media/raph/osShared" = {
      device = config.windowManager.osShared.device;
      fsType = "exfat";
      options = [
        "x-gvfs-show"
        "x-gvfs-name=osShared"
        "nofail"
        "noatime"
        "uid=1000"
        "gid=100"
        "umask=000"
      ];
    };
  };
}
