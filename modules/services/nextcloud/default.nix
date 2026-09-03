{ config, pkgs, lib, options, ... }:
{
  imports = [ 
    ./nginx.nix
    ./postgresql.nix
    ./fail2ban.nix
  ];
  options.services.raphNextcloud = {
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
  lib.mkIf config.services.raphNextcloud.enable  {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud34;
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
        enabledPreviewProviders = options.services.nextcloud.settings.type.emptyValue.value.enabledPreviewProviders ++ [ "OC\\Preview\\HEIC" ];
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
    
    systemd.services.nextcloudUpdateCache = {
      description = "Update Nextcloud's understanding of its content";

      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };

      script = ''    
        ${config.services.nextcloud.occ}/bin/nextcloud-occ files:scan --all'';
    };

    systemd.tmpfiles.rules = [
        "d ${dataPath}/nextcloud 0755 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/data 0755 nextcloud nextcloud -"
        "d ${dataPath}/nextcloud/db-backups 0755 postgres postgres -"
    ];
  };
}
