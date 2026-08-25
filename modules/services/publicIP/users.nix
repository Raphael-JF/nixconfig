
{ lib, config, ... }:
{
  config = {
    users.groups.publicIpUser = {}; 
    users.users = {
        publicIpUser = {
          isSystemUser = true;
          group = "publicIpUser";
          home = "/var/lib/publicIpUser";
          createHome = true;
          homeMode = "770";             
        };
        raph.extraGroups = [ "publicIpUser" ];
    };
  };
}
