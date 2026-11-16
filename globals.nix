{ inputs, lib }:
{
  public-ip = lib.strings.trim (
    builtins.readFile "${inputs.public-ip-repo}/ip.txt"
  );
  desktop = {
    ip = "192.168.1.104";
    mac = "18:c0:4d:a3:ec:41";
  };

  server = {
    ip = "192.168.1.37";
  };
}
