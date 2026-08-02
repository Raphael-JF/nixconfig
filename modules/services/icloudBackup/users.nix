{ lib, config, ... }:
{
  config = {
    users.groups.icloudPhotos = {}; 
    users.users = 
      (lib.mapAttrs' # Map on configured instances and associate each instance with a system user
        (name: cfg: lib.nameValuePair
          ("icloudSystemUser-${name}")
          (
            {
              isSystemUser = true;
              group = "icloudPhotos";
              home = "/var/lib/icloudBackup/${name}";
              createHome = true;
              homeMode = "770";             
            } 
          )
        )
        (config.services.icloudBackup.instances))
    //
    {
      raph.extraGroups = [ "icloudPhotos" ];
    };
  };
}
