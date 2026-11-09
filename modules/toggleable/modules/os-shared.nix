{ config, lib, ...}:
{
  options = {
    raph.os-shared.device = lib.mkOption {
      type = lib.types.path;
      description = "Path to the shared OS partition.";
    };
  };
  config = {
    fileSystems."/run/media/raph/osShared" = {
      device = config.raph.os-shared.device;
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
