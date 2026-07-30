{ pkgs, lib, config, ... }:
{

  config = {


    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-extensions-app
      gnome.gnome-shell-extension-prefs
      gnome.gnome-shell-extension-manager
      gnome.gnome-shell-extension-desktop-icons-ng
      gnome.gnome-shell-extension-dash-to-dock
      gnome.gnome-shell-extension-caffeine
      gnome.gnome-shell-extension-clipboard-indicator
      gnome.gnome-shell-extension-clipboard-history
      gnome.gnome-shell-extension-clipboard-indicator-git
      gnome.gnome-shell-extension-clipboard-history-git
    ];
    
    services.libinput.enable = true; # Enable libinput for touchpad and mouse support
  
    services.xserver = {
      enable = true;
      xkb.layout = "fr";
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # To disable installing GNOME's suite of applications
    # and only be left with GNOME shell.
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
    
    programs.dconf.profiles.user.databases.lockAll = false;
    programs.dconf.profiles.user.databases.settings = {
      # --- Extensions ---
      "org/gnome/shell" = {
          enabled-extensions = [
              "copyous@boerdereinar.dev"
          ];
          disabled-extensions = [
          ];
      };

      "org/gnome/shell/extensions/copyous" = {
          clipboard-orientation = "vertical";
          clipboard-position-horizontal = "top";
          clipboard-position-vertical = "fill";
          clipboard-size = 500;
          disable-hljs-dialog = true;
          dynamic-item-height = true;
          header-controls-visibility = "visible-on-hover";
          item-height = 100;
          item-width = 300;
          show-at-pointer = true;
          show-header = false;
          show-indicator = false;
          sync-primary = true;
          open-clipboard-dialog-shortcut = ["<Super>v"];

      };
      "org/gnome/shell/extensions/copyous/file-item" = {
          file-preview-visibility = "file-info";
      };
      "org/gnome/shell/extensions/copyous/link-item" = {
          link-preview-orientation = "horizontal";
      };

      # --- Custom keybindings ---
      "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "kitty";
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

      "org/gnome/shell/keybindings" = {
          toggle-message-tray = [ ];
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
      };

      "org/gnome/desktop/interface" = {
          enable-hot-corners = false;
      };
      "org/gnome/shell" = {
      startup-overview = false;
      };
      "org/gnome/desktop/session" = {
          idle-delay = lib.gvariant.mkUint32 900;
      };
    };
  };
}
