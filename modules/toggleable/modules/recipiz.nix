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
      backendPort = globals.server.ports.recipiz-backend;
      frontendUrl = "recipiz.${globals.server-url}";
    };
  };
}
