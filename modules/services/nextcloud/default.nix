{ config, pkgs, lib, ... }:
{
  imports = [ 
    ./nginx.nix
    ./postgresql.nix
    ./fail2ban.nix
  ];
  options.services.custom-nextcloud = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Nextcloud service.";
    };
  };
  config =
  let
    dataPath = config.services.backup.devices.data.path;
  in
  lib.mkIf config.services.custom-nextcloud.enable  {
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

    # Icloud photos inside nextcloud
    users.users."nextcloud".extraGroups = [ "icloudPhotos" ];
    fileSystems."/data/nextcloud/data/raph/files/Photos" = {
      fsType = "none";
      device = "/data/icloudBackup/raph";
      options = [ "bind" ];
    };

    systemd.tmpfiles.rules = [
        "d ${dataPath}/nextcloud 0755 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/data 0755 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/db-backups 0755 postgres postgres -"
    ];
  };
}
