{ config, pkgs, lib, ... }:


{

    
home-manager.users.raph = {
    imports = [
        ./gnome.nix
    ];

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
        platformio
    ];

    

    # wayland.windowManager.hyprland = {
    #     settings = import ./hyprland/hyprland.nix;
    #     enable = false;
    #     systemd.enable = false;
    # };
    home.stateVersion = "25.11";
};
}
