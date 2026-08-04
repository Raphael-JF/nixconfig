{pkgs, ...}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;

    ensureDatabases = [ "nextcloud" ];

    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };
}
