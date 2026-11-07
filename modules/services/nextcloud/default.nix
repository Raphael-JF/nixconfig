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
    dataPath = config.services."backup-usb".devices.data.path;
  in
  lib.mkIf config.services.raphNextcloud.enable  {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud35;
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
      };
    };

    # Icloud photos inside nextcloud
    users.users."nextcloud".extraGroups = lib.mkIf config.services.icloudBackup.enable  [ "icloudPhotos" ];
    
    systemd.services."nextcloud-update-cache" = {
      description = "Update Nextcloud's file cache";

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
    ];
  };
}
