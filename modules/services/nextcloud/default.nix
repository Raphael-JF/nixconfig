{ config, pkgs, lib, ... }:
{
  imports = [ 
    ./nginx.nix
    ./postgresql.nix
    ./fail2ban.nix
  ];
  config = 
  let
    dataPath = config.services.backup.devices.data.path;
  in
  {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud32;
      hostName = "files.82.126.172.121.nip.io";
      https = true;      
      datadir = "${dataPath}/nextcloud";
      configureRedis = true; 

      phpOptions = {
        "opcache.interned_strings_buffer" = "10";
      };

      settings = {
        maintenance_window_start = 1;
        default_phone_region = "FR";
        log_type = "systemd";
      };

      config = {
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        adminuser = "raph";
        adminpassFile = config.sops.secrets.nextcloudAdminPassword.path;
      };
    };
    users.users."nextcloud".extraGroups = [ "icloudPhotos" ];
    fileSystems."/data/nextcloud/data/raph/files/Photos" = {
      fsType = "none";
      device = "/data/icloudBackup/raph";
      options = [ "bind" ];
        
    };

    systemd.tmpfiles.rules = [
        "d ${dataPath}/nextcloud 0750 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/data 0750 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/db-backups 0750 postgres postgres -"
    ];
  };
}
