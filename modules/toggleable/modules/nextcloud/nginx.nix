{ globals, ... }:
{
  services.nginx.virtualHosts."files.${globals.server-url}" = {
    forceSSL = true;
    enableACME = true;
  };
}
