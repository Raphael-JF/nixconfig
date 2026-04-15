{ config, pkgs, ... }:

{
  home.username = "raph";
  home.homeDirectory = "/home/raph";

  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 2;
    }; 
  };
    home.stateVersion = "25.11";

}