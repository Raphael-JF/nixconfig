{ inputs, lib }:
{
  server-url = "raph-server.duckdns.org";

  ports = {
    ssh = 22;

    http = 80;
    https = 443;

    recipiz-backend = 3000;

    homepage = 8082;
    homepage-auth = 8083;
    healthchecks = 8000;

    wg-server-home = 51820;
    wg-desktop-gaming = 51821;
  };

  desktop = {
    ip = "192.168.1.104";
    mac = "18:c0:4d:a3:ec:41";
    luks-root-part = "/dev/disk/by-uuid/44744f5c-5d80-4334-adfb-320cd4ecbda6";

    wg-gaming-ip = "10.101.0.1";
  };

  server = {
    ip = "192.168.1.37";
    network-interface = "enp0s20f0u4";

    wg-home-ip = "10.100.0.1";
  };

  laptop = {
    wg-gaming-ip = "10.101.0.2";
    wg-home-ip = "10.100.0.2";
  };
}
