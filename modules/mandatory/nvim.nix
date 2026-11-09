{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.myNvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
