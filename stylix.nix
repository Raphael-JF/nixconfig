{ config, pkgs, ... }:

{
  stylix.enable = false;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark.yaml";

  stylix.targets.gnome.enable = false;
}