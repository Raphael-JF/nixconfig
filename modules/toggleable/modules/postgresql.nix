{pkgs, ...}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    authentication = pkgs.lib.mkOverride 10 ''
        local   all   all   peer
      '';
  };

  systemd.tmpfiles.rules = [
    "d /data/backupPostgresql 0711 postgres postgres -"
  ];
}
