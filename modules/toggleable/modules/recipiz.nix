{ inputs, globals, ... }:
{
  imports = [
    inputs.recipiz.nixosModules.default
    ./postgresql.nix
  ];
  config = {
    services.recipiz = {
      enable = true;

      packageDirectory = "/var/lib/recipiz";
      backendPort = 3000;
      frontendUrl = "https://recipiz.${globals.server-url}";
    };
  };
}
