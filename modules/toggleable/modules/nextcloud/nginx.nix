{ ... }:
{
  services.nginx.virtualHosts."files.82.126.172.121.nip.io" = {
    forceSSL = true;
    enableACME = true;
  };
}
