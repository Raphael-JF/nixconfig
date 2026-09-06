{ pkgs, ... }:
{
  systemd.services.backupPostgresql = {
    description = "Backup all PostgreSQL databases";

    after = [ "postgresql.service" ];
    requires = [ "postgresql.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
    };

    script = ''
      ${pkgs.coreutils}/bin/mkdir -p /data/backupPostgresql

      ${pkgs.postgresql_18}/bin/pg_dumpall \
        --file=/data/backupPostgresql/all.sql
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
