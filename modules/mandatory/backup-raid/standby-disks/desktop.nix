{ pkgs, config, ... }:

let
  cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
  mount = "${pkgs.util-linux}/bin/mount";
  umount = "${pkgs.util-linux}/bin/umount";
  mountpoint = "${pkgs.util-linux}/bin/mountpoint";
  hdparm = "${pkgs.hdparm}/bin/hdparm";

  keyfile = config.sops.secrets.backup-raid.path;
  
  backup500 = {
    partition = "/dev/disk/by-uuid/e7292176-5db8-41b9-a3a6-893dfa418d1f";
    disk = "/dev/disk/by-id/wwn-0x50014ee659f75410" ;
  };

  backup320 = {
    partition = "/dev/disk/by-uuid/a63b5b83-505d-4599-86f9-448fc8f2928b";
    disk = "/dev/disk/by-id/wwn-0x5000cca317ceeab4" ;
  };
in 
{
  sops.secrets.backup-raid = {
    sopsFile = ../../../../secrets/keys/backup-raid.key.enc;
    format = "binary";
    mode = "0400";
  };

  systemd.tmpfiles.rules = [
    "d /backup 0700 root root -"
  ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "backup-raid-start" ''
      set -eu

      opened500=0
      opened320=0

      cleanup() {
        if [ "$opened320" = 1 ]; then
          ${cryptsetup} close backup320 || true
        fi
        if [ "$opened500" = 1 ]; then
          ${cryptsetup} close backup500 || true
        fi
      }

      trap cleanup EXIT

      test -r ${keyfile}

      if [ -e /dev/mapper/backup500 ] &&
         [ -e /dev/mapper/backup320 ]; then
        if ${mountpoint} -q /backup; then
          echo "Backup RAID already mounted"
          exit 0
        fi

        echo "Both LUKS mappings are open, but RAID is not mounted" >&2
        exit 1
      fi

      if [ -e /dev/mapper/backup500 ] ||
         [ -e /dev/mapper/backup320 ]; then
        echo "Backup RAID partially unlocked" >&2
        exit 1
      fi

      if ${mountpoint} -q /backup; then
        echo "/backup is already mounted" >&2
        exit 1
      fi

      ${cryptsetup} open \
        --key-file ${keyfile} \
        ${backup500.partition} backup500
      opened500=1

      ${cryptsetup} open \
        --key-file ${keyfile} \
        ${backup320.partition} backup320
      opened320=1

      ${mount} -t btrfs \
        -o compress=zstd:9,noatime \
        /dev/mapper/backup500 /backup

      trap - EXIT
    '')

    (pkgs.writeShellScriptBin "backup-raid-stop" ''
      set -eu

      if ${mountpoint} -q /backup; then
        ${umount} /backup
      fi

      if [ -e /dev/mapper/backup320 ]; then
        ${cryptsetup} close backup320
      fi

      if [ -e /dev/mapper/backup500 ]; then
        ${cryptsetup} close backup500
      fi
      
      ${hdparm} -y "${backup320.disk}"
      ${hdparm} -y "${backup500.disk}"
    '')
  ];

  systemd.services.backup-raid-standby = {
    description = "Put backup HDDs in standby after boot";

    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "backup-raid-standby" ''
        ${hdparm} -S 36 "${backup320.disk}"
        ${hdparm} -S 36 "${backup500.disk}"
      '';
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "raph" ];

      commands = [
        {
          command = "/run/current-system/sw/bin/backup-raid-start";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/backup-raid-stop";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
