{ lib, config, ... }:
{
  config = {
    users.groups.publicIp = {}; 
    users.users = {
      publicIp = {
        isSystemUser = true;
        group = "publicIp";
        home = "/var/lib/publicIp";
        createHome = true;
        homeMode = "770";             
      }; 
    }
    //
    {
      raph.extraGroups = [ "publicIp" ];
    };
  };
}
