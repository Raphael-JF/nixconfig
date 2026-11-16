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
      frontendUrl = "recipiz.${globals.server-url}";
    };
  };
}
