
{ lib, config, ... }:
{
  config = {
    users.groups.publicIpUser = {}; 
    users.users.publicIpUser = {
                   isSystemUser = true;
              group = "icloudPhotos";
              home = "/var/lib/icloudBackup/${name}";
              createHome = true;
            homeMode = "770";             
            } 
    //
    {
      raph.extraGroups = [ "icloudPhotos" ];
    };
  };
}
