{ config, pkgs, lib, ... }:

{
  # ===== IMPORTS =====
  imports = [
    ./hardware-configuration.nix
  ];

  # ===== NIX =====
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ===== BOOT =====
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ===== NETWORK =====
  networking.hostName = "raph-maison";
  networking.networkmanager.enable = true;

  # ===== TIME =====
  time.timeZone = "Europe/Paris";

  # ===== X11 / GNOME =====
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # clavier
  services.xserver.xkb.layout = "fr";

  # ===== UDEV / EMBEDDED =====
  services.udev.packages = [
    pkgs.platformio-core
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

  # ===== PROGRAMS =====
  programs.firefox.enable = true;
  programs.bash.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    avrdude
  ];

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

  # ===== USB / APPLE =====
  services.usbmuxd.enable = true;

  # ===== UNFREE =====
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "vscode" ];

  # ===== PACKAGES =====
  environment.systemPackages = with pkgs; [
    # home-manager

    vscode
    git
    valgrind
    evince
    gdb
    direnv

    (python3.withPackages (python-pkgs: with python-pkgs; [
      platformio
      numpy
      matplotlib
    ]))

    gcc
    gsl
    gnumake
    graphviz
    libimobiledevice
    nodejs
    libclang
  ];

  # ===== STATE VERSION =====
  system.stateVersion = "25.11";
}