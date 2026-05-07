{ config, pkgs, lib, ... }:

{
dconf.settings = {

    # --- Custom keybindings ---
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

    # --- Window manager ---
    "org/gnome/desktop/wm/keybindings" = {
    move-to-workspace-left  = ["<Shift><Alt>x"];
    move-to-workspace-right = ["<Shift><Alt>c"];
    switch-to-workspace-right = ["<Alt>c"];
    switch-to-workspace-left  = ["<Alt>x"];

    switch-applications = [ ];
    switch-applications-backward = [ ];

    switch-group = [ ];
    switch-group-backward = [ ];

    switch-windows = [ "<Alt>Tab" ];
    switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    # --- Touchpad ---
    "org/gnome/desktop/peripherals/touchpad" = {
    click-method = "areas";
    two-finger-scrolling-enabled = true;
    };

    # --- Night light ---
    "org/gnome/settings-daemon/plugins/color" = {
    night-light-enabled = true;
    night-light-schedule-automatic = false;
    night-light-schedule-from = 0.0;
    night-light-schedule-to = 0.0;
    night-light-temperature = lib.gvariant.mkUint32 3526;
    };

    # --- App switcher ---
    "org/gnome/shell/app-switcher" = {
    current-workspace-only = true;
    };

    # --- Workspaces ---
    "org/gnome/desktop/wm/preferences" = {
    num-workspaces = 2;
    };

    "org/gnome/mutter" = {
    dynamic-workspaces = false;
    workspaces-only-on-primary = false;
    attach-modal-dialogs = false;
    focus-new-windows = "smart";
    focus-change-on-pointer-rest = false;
    focus-on-map = true;
    focus-mode = "click";
    action-double-click-titlebar = "toggle-maximize";
    action-middle-click-titlebar = "toggle-maximize";
    };

    "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
    };
    "org/gnome/shell" = {
    startup-overview = false;
    };
};
}