{ inputs, ... }:
{
  imports = [
    inputs.recipiz.nixosModules.default
  ];

  services.recipiz = {
    enable = true;
    packageDirectory = "/var/lib/recipiz";

    backendPort = 3000;
    frontendUrl = "https://recipiz.82.126.172.121.nip.io";
  };
}
