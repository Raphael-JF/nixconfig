{ config, pkgs, ... }:


{
  home-manager.users.raph = {
    home.username = "raph";
    home.homeDirectory = "/home/raph";

    programs.home-manager.enable = true;

    # dconf.settings = {
    #     # "org/gnome/desktop/interface" = {
    #         # color-scheme = "prefer-dark";
    #     # };
    #     "org/gnome/desktop/wm/preferences" = {
    #         num-workspaces = 2;
    #     }; 
    # };

    wayland.windowManager.hyprland = {
        enable = true;

        settings = {
        "$mod" = "SUPER";

        bind = [
            "$mod, F, exec, firefox"
            ", Print, exec, grimblast copy area"
        ];

        monitor = ",preferred,auto,1";

        exec-once = [
            "waybar"
            "eww daemon"
        ];
        };

    };
        home.stateVersion = "25.11";
    };
}
