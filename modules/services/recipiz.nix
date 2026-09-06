{ inputs, ... }:
{
  imports = [
    inputs.recipiz.nixosModules.default
  ];
  services.recipiz.enable = true;
}
