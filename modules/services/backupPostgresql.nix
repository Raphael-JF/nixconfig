{ pkgs, ... }:
{
  systemd.services.backupPostgresql = {
    description = "Backup all PostgreSQL databases";

    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      UMask = "0077";
    };

    script = ''
      ${pkgs.coreutils}/bin/mkdir -p /data/backupPostgresql
      ${pkgs.coreutils}/bin/chown postgres:postgres /data/backupPostgresql
      ${pkgs.coreutils}/bin/chmod 700 /data/backupPostgresql

      ${pkgs.postgresql_18}/bin/pg_dumpall \
        --file=/data/backupPostgresql/all.sql

      ${pkgs.coreutils}/bin/chmod 600 /data/backupPostgresql/all.sql
    '';
  };

  systemd.timers.backupPostgresql = {
    description = "Daily backup of all PostgreSQL databases";

    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
  };
}
