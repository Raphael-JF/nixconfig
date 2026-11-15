{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.myNvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  environment.variables = {
    EDITOR = "${pkgs.neovim}/bin/nvim --clean";
    VISUAL = "${pkgs.neovim}/bin/nvim --clean";
    SOPS_EDITOR = "${pkgs.neovim}/bin/nvim --clean";
  };
}
