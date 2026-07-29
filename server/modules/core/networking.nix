{ hostname, ... }:
{
  networking.hostName = "raph-${hostname}";
  networking.networkmanager.enable = true;
}
