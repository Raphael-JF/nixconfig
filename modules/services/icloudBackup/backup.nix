{ pkgs, lib, config, ... }:
{
  config = lib.mkIf config.services.icloudBackup.enable {
    # First, map the "Photos", stored on the backup disk (create this folder if non-existent), to the home of each instance.
    # Then, Create a systemd service for each instance
    # Finaly, create a systemd timer for each instance to run the service periodicaly.

    
    systemd.tmpfiles.rules =
    lib.mapAttrsToList
      (name: cfg:
        "z ${config.services.backup.devices.data.path}/icloudBackup/${name} 0770 icloudSystemUser-${name} icloudPhotos -"
        # z stands for create dir (just change permissions if it exists), 0770 is the permission, icloudSystemUser-${name} is the owner, icloudPhotos is the group, and - means no age limit (don't delete it after X days)
      )
      config.services.icloudBackup.instances;


    fileSystems = 
      lib.mapAttrs' 
        (name : cfg: lib.nameValuePair
          ("/var/lib/icloudBackup/${name}/Photos") # the folder that will be the mock
          {
            device = "${config.services.backup.devices.data.path}/icloudBackup/${name}"; # the actual folder that will be twice visible
            fsType = "none";
            options = [ "bind" ];
          }
        )
        config.services.icloudBackup.instances;


    systemd.services =
      lib.mapAttrs' 
      (name: cfg: lib.nameValuePair
          ("icloudBackup-${name}")
          (
            {
              description = "iCloud backup for ${name}";

              serviceConfig = {
                Type = "oneshot";
                User = "icloudSystemUser-${name}";
                UMask = "0007";
             };
              script = ''
                ${pkgs.icloudpd}/bin/icloudpd \
                  --directory ~/Photos \
                  --folder-structure "{:%Y/%m}" \
                  --username ${cfg.appleID}\
                  --cookie-directory /var/lib/icloudBackup/${name}/cookies \
                  && \
                  nextcloud-occ files:scan --all
              '';
            }
          )
        )
        config.services.icloudBackup.instances;

    systemd.timers = 
      lib.mapAttrs' (name: cfg: lib.nameValuePair
        ("icloudBackup-${name}")
        (
          {
            description = "Timer for iCloud backup for ${name}";

            timerConfig = {
              OnCalendar = "*-*-* 03:00:00"; # Run every day at 3 AM
              Persistent = true; # Run the job immediately if it was missed (e.g., if the computer was off)
            };

            wantedBy = [ "timers.target" ];
          }
        )
      )
      config.services.icloudBackup.instances;
   
  };
}
