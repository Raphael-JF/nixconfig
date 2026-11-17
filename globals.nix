{ inputs, lib }:
{
  server-url = "raph-server.duckdns.org";
  desktop = {
    ip = "192.168.1.104";
    mac = "18:c0:4d:a3:ec:41";
    luks-root-part = "/dev/disk/by-uuid/44744f5c-5d80-4334-adfb-320cd4ecbda6";
  };

  server = {
    ip = "192.168.1.37";
  };
}
