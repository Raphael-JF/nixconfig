{ config, pkgs, lib, ... }:


{
    
home-manager.users.raph = {
    home.username = "raph";
    home.homeDirectory = "/home/raph";

    programs.home-manager.enable = true;
    home.packages = with pkgs; [
        # wl-clipboard
        # cliphist
        # grimblast
        # wofi
        # waybar
        firefox
    ];

    dconf.settings = {
        "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            ];  
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Terminal";
            command = "kgx";
            binding = "<Ctrl><Alt>T";
        };

        "org/gnome/desktop/wm/keybindings" = {
            move-to-workspace-left=["<Shift><Alt>x"];
            move-to-workspace-right=["<Shift><Alt>c"];
            switch-to-workspace-right = [ "<Alt>c" ];
            switch-to-workspace-left  = [ "<Alt>x" ];
        };
        "org/gnome/desktop/peripherals/touchpad" = {
            click-method = "areas";
            two-finger-scrolling-enabled	= true;	
        };  
        "org/gnome/settings-daemon/plugins/color" = {
            night-light-enabled = true;
            night-light-schedule-automatic = false;
            night-light-schedule-from = 0.0;
            night-light-schedule-to = 0.0;
            night-light-temperature = lib.gvariant.mkUint32 3526;
        };
        "org/gnome/shell/app-switcher" = {
            current-workspace-only=true;

        };

        "org/gnome/desktop/wm/preferences" = {
            num-workspaces = 2;
            
        };
        "org/gnome/mutter" = { 
            dynamic-workspaces = false;
        };
    };

    # wayland.windowManager.hyprland = {
    #     settings = import ./hyprland/hyprland.nix;
    #     enable = false;
    #     systemd.enable = false;
    # };
    home.stateVersion = "25.11";
};
}
