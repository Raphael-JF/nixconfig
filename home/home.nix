{ config, pkgs, ... }:


{
imports = [
  ./hyprland/hyprland.nix
];
    
home-manager.users.raph = {
    home.username = "raph";
    home.homeDirectory = "/home/raph";

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        wl-clipboard
        cliphist
        grimblast
        wofi
        waybar
        firefox
    ];

    # dconf.settings = {
    #     # "org/gnome/desktop/interface" = {
    #         # color-scheme = "prefer-dark";
    #     # };
    #     "org/gnome/desktop/wm/preferences" = {
    #         num-workspaces = 2;
    #     }; 
    # };

    wayland.windowManager.hyprland = {
        settings = import ./hyprland/hyprland.nix;
        enable = true;
    };
    home.stateVersion = "25.11";
};
}
