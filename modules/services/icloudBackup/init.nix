{config, lib, pkgs,...}:
{
  systemd.services =
  lib.mapAttrs'
    (name: _: lib.nameValuePair
      "icloudBackupInit-${name}"
      {
        wantedBy = [ "multi-user.target" ];

        after = [ "mnt-backupDisk.mount" ];
        requires = [ "mnt-backupDisk.mount" ];

        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;

        script = ''
          if ! ${pkgs.btrfs-progs}/bin/btrfs subvolume show /mnt/backupDisk/icloudBackup/${name} >/dev/null 2>&1; then
            ${pkgs.btrfs-progs}/bin/btrfs subvolume create /mnt/backupDisk/icloudBackup/${name}
            chown icloudSystemUser-${name}:icloudPhotos /mnt/backupDisk/icloudBackup/${name}
            chmod 770 /mnt/backupDisk/icloudBackup/${name}
          fi
        '';
      })
    config.services.icloudBackup.instances;
}
