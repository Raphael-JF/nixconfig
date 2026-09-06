{ inputs, ... }:
{
  imports = [
    inputs.recipiz.nixosModules.default
  ];
}
