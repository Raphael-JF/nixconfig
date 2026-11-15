{ pkgs, config, lib, ... }:

let
  cryptsetup = "${pkgs.cryptsetup}/bin/cryptsetup";
  mount = "${pkgs.util-linux}/bin/mount";
  umount = "${pkgs.util-linux}/bin/umount";
  mountpoint = "${pkgs.util-linux}/bin/mountpoint";
  hdparm = "${pkgs.hdparm}/bin/hdparm";

  keyfile = config.sops.secrets.backup-raid.path;


  devices = { # partitions
    backup500 = "/dev/disk/by-uuid/e7292176-5db8-41b9-a3a6-893dfa418d1f";
    backup320 = "/dev/disk/by-uuid/a63b5b83-505d-4599-86f9-448fc8f2928b";
  };


  disks = [ # disks
    "/dev/disk/by-id/wwn-0x5000cca317ceeab4" 
    "/dev/disk/by-id/wwn-0x50014ee659f75410"
  ];

standby = doNow: pkgs.writeShellScript "backup-raid-standby" ''
    set -eu

    for disk in ${lib.escapeShellArgs disks}; do
      ${hdparm} ${if doNow then "-y" else "-S 36"} "$disk"
    done
  '';


  start = pkgs.writeShellScript "backup-raid-start" ''
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

    if [ -e /dev/mapper/backup500 ] ||
       [ -e /dev/mapper/backup320 ]; then
      echo "Backup LUKS mappings already open" >&2
      exit 1
    fi

    if ${mountpoint} -q /backup; then
      echo "/backup is already mounted" >&2
      exit 1
    fi

    ${cryptsetup} open \
      --key-file ${keyfile} \
      ${devices.backup500} backup500
    opened500=1

    ${cryptsetup} open \
      --key-file ${keyfile} \
      ${devices.backup320} backup320
    opened320=1

    ${mount} -t btrfs \
      -o compress=zstd:9,noatime \
      /dev/mapper/backup500 /backup

    trap - EXIT
  '';

  stop = pkgs.writeShellScript "backup-raid-stop" ''
    set -eu

    if ${mountpoint} -q /backup; then
      ${umount} /backup
    fi

    ${cryptsetup} close backup320
    ${cryptsetup} close backup500

    ${standby true}
  '';
in
{

  sops.secrets.backup-raid = {
    sopsFile = ../../../secrets/backup-raid.key.enc;
    format = "binary";
    mode = "0400";
  };

  systemd.tmpfiles.rules = [
    "d /backup 0700 root root -"
  ];

  systemd.services.backup-raid = {
    description = "Encrypted Btrfs RAID1 backup";

    # Pas de wantedBy : aucun démarrage automatique.
    unitConfig = {
      ConditionPathExists = keyfile;
    };

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = start;
      ExecStop = stop;
      TimeoutStartSec = 120;
      TimeoutStopSec = 120;
    };
  };

  systemd.services.backup-raid-standby = {
    description = "Put backup HDDs in standby after boot";

    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    before = [ "backup-raid.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = standby false;
    };
  };

}
