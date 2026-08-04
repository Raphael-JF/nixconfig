{ config, pkgs, lib, ... }:
{
  imports = [ 
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

      hostName = "localhost";

      datadir = "${dataPath}/nextcloud";
      configureRedis = true; 

      phpOptions = {
            "opcache.interned_strings_buffer" = "10";
      };

      config = {
        dbtype = "pgsql";
        dbname = "nextcloud";
        dbuser = "nextcloud";
        dbhost = "/run/postgresql";
        adminuser = "raph";
        adminpassFile = config.sops.secrets.nextcloudAdminPassword.path;
      };
      # settings = {
        # memcache.local = "\\OC\\Memcache\\APCu";
        # memcache.locking = "\\OC\\Memcache\\Redis";
        # redis = {
        #   host = "/run/redis-nextcloud/redis.sock";
        # }; 
      # };
    };

    systemd.tmpfiles.rules = [
      "d ${dataPath}/nextcloud 0750 nextcloud nextcloud -"
      "d ${dataPath}/nextcloud/data 0750 nextcloud nextcloud -"
      "d ${dataPath}/nextcloud/db-backups 0750 postgres postgres -"
    ];
  };
}
