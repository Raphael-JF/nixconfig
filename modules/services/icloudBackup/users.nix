{ lib, config, ... }:
{
  config = {
    users.groups =
      lib.mapAttrs' # Map on configured instances and associate each instance with a system group
        (name: cfg: lib.nameValuePair
          ("icloudBackup")
          (
            {
              isSystemGroup = true;
            }
          )
        )
        (config.services.icloudBackup.instances);

    users.users = 
      lib.mapAttrs' # Map on configured instances and associate each instance with a system user
        (name: cfg: lib.nameValuePair
          ("icloudSystemUser-${name}")
          (
            {
              isSystemUser = true;
              group = "icloudSystemUser-${name}";
              home = "/var/lib/icloudBackup/${name}";
              createHome = true;
            }
          )
        )
        (config.services.icloudBackup.instances);

  };
}
