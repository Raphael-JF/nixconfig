{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.my-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
