{ inputs, ... }:
{
  imports = [
    inputs.recipiz.nixosModules.default
  ];

  services.recipiz = {
    enable = true;
    packageDirectory = "/var/lib/recipiz";

    backendPort = 3000;
    frontendPort = 5173;
    corsOrigin = "https://recipiz.82.126.172.121.nip.io";
    database = {
      host = "localhost";
      name = "recipiz";
      user = "recipiz";
   };
  };
}
