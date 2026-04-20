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
    ];

programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.premier = {
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;
        enableUpdateCheck = false;

        # The extensions Visual Studio Code should be started with
        extensions = with pkgs.vscode-extensions; [

        # --- Nix ---
        bbenoist.nix

        # --- C / C++ ---
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack
        ms-vscode.cmake-tools
        ms-vscode.cpp-devtools

        # --- Python ---
        ms-python.python
        ms-python.vscode-pylance

        # --- Debug JS (souvent utile indirectement) ---
        ms-vscode.js-debug

        # --- UI / UX ---
        usernamehw.errorlens

        ];
        # Defines global user snippets
        globalSnippets = null;
        # Keybindings written to Visual Studio Code's keybindings.json
        keybindings = builtins.fromJSON (builtins.readFile ./vscode/keybindings.json);
        # Defines user snippets for different languages
        languageSnippets = {
            c = builtins.fromJSON (builtins.readFile ./vscode/snippets/c.json);
            latex = builtins.fromJSON (builtins.readFile ./vscode/snippets/latex.json);
        };
        # Configuration written to Visual Studio Code's mcp.json
        userMcp = null;
        # Configuration written to Visual Studio Code's settings.json
        userSettings = builtins.fromJSON (builtins.readFile ./vscode/settings.json);
        # Configuration written to Visual Studio Code's tasks.json
        userTasks = null;
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
