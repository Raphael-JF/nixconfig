{pkgs, ...}:
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_18;
    authentication = pkgs.lib.mkOverride 10 ''
        local   all   all   peer
      '';
  };
}
