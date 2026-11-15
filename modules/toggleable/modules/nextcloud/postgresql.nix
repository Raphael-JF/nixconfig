{pkgs, ...}:
{
  systemd.services.nextcloud-setup = {
    requiresMountsFor = ["/data"];
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  services.postgresql = {
    ensureDatabases = [ "nextcloud" ];

    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };
}
