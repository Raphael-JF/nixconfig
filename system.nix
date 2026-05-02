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
    services.displayManager.defaultSession = "gnome";
    services.displayManager.hiddenUsers = [ ];
    services.desktopManager.gnome.enable = true;

    services.accounts-daemon.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm.enableGnomeKeyring = true;


    programs.hyprland = {
        enable = false;
        withUWSM = true; # recommended for most users
        xwayland.enable = true; # Xwayland can be disabled.
    };

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

    # ===== USERS =====
    users.users.raph = {
        isNormalUser = true;
        extraGroups = [ "wheel" "dialout" ];
    };

    system.activationScripts.accountsServiceRaph = ''
        mkdir -p /var/lib/AccountsService/users
        cat > /var/lib/AccountsService/users/raph <<'EOF'
    [User]
    Language=
    XSession=gnome
    SystemAccount=false
    EOF
        chown root:root /var/lib/AccountsService/users/raph
        chmod 644 /var/lib/AccountsService/users/raph
    '';

    systemd.tmpfiles.rules = [
        "d /var/lib/AccountsService/users 0755 root root - -"
        "f /var/lib/AccountsService/users/raph 0644 root root - [User]\nLanguage=\nXSession=gnome\nSystemAccount=false\n"
    ];

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
