{ config, pkgs, lib, ... }:

{
# ===== OPTIONS =====
options.raph.hostType = lib.mkOption {
    type = lib.types.enum [ "desktop" "laptop" ];
    description = "Device profile used by shared configuration.";
};

# ===== IMPORTS =====
imports = [
    /etc/nixos/hardware-configuration.nix
];

config = {
    # ===== NIX =====
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # ===== BOOT =====
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # ===== NETWORK =====
    networking.networkmanager.enable = true;

    # ===== TIME =====
    time.timeZone = "Europe/Paris";

    # ===== X11 / GNOME =====
    services.xserver.enable = true;

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
    };

    # ===== GNOME (clean) =====
    environment.gnome.excludePackages = with pkgs; [
        cheese
        epiphany
        gedit
        simple-scan
        yelp
        file-roller
        geary
        seahorse
        gnome-calendar
        gnome-clocks
        gnome-contacts
        gnome-music
        gnome-photos
        gnome-weather
    ];

    # ===== KEYBOARD =====
    services.xserver.xkb.layout = "fr";

    # pour les formats de dates etc.
    i18n = {
      defaultLocale = "fr_FR.UTF-8";
      supportedLocales = [
        "fr_FR.UTF-8/UTF-8"
      ];
    };

    # ===== UDEV / EMBEDDED =====
    services.udev.packages = [
        pkgs.platformio-core.udev
        pkgs.openocd
    ];

    # ===== PRINT =====
    services.printing.enable = true;

    # ===== INPUT =====
    services.libinput.enable = true;

    # ===== USBMUXD =====
    services.usbmuxd = {
        enable = true;
        package = pkgs.usbmuxd2;
    };


    # ===== USERS =====
    users.users.raph = {
        isNormalUser = true;
        extraGroups = [ "wheel" "dialout" ];
    };


    # ===== PROGRAMS =====
    programs.firefox.enable = true;
    programs.bash.enable = true;

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
        avrdude
    ];

    # ===== UNFREE =====
    nixpkgs.config.allowUnfree = true;

    # ===== PACKAGES =====
    environment.systemPackages = with pkgs; [

    ];



    # ===== STATE VERSION =====
    system.stateVersion = "25.11";
};
}
