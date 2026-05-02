{ config, pkgs, lib, ... }:


let
    projectSituations = import ../make-codium/project-situations.nix { inherit pkgs; };
in
let
    sshIdentity = if config.raph.hostType == "desktop" then "~/.ssh/desktop" else "~/.ssh/laptop";
in

{

    
home-manager.users.raph = {
    imports = [
        ./gnome.nix
    ];


    home.username = "raph";
    home.homeDirectory = "/home/raph";

    
    home.file.".ssh/config_source" = {
        text = ''
        Host enseirb
        HostName ssh.enseirb-matmeca.fr
        User rjontef
        IdentityFile ${sshIdentity}
        AddKeysToAgent yes
        ForwardAgent yes

        Host almapedago travail64
        User rjontef
        ProxyJump enseirb

        Host thor thor.enseirb-matmeca.fr
        HostName thor.enseirb-matmeca.fr
        IdentityFile ${sshIdentity}
        IdentitiesOnly yes
        AddKeysToAgent yes

        Host github.com
        User git
        IdentityFile ${sshIdentity}
        IdentitiesOnly yes
        AddKeysToAgent yes
        '';

    onChange = ''
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        cat ~/.ssh/config_source > ~/.ssh/config
        chmod 600 ~/.ssh/config
    '';
};
    home.file.".config/monitors.xml". = lib.optionalAttrs (config.raph.hostType == "desktop") {
        source = ./monitors.xml;
    };
    programs.git = {
        enable = true;
        settings = {
            user.name = "Raphaël Jontef";
            user.email = "raphael.jontef@enseirb-matmeca.fr";
        };
        ignores = [
            ".clangd"
            ".clangd.local"
            "compile_commands.json"
            ".direnv"
            "flake.nix"
            "flake.lock"
            ".envrc"
            "*.idx"
        ];
    };

    programs.home-manager.enable = true;
    #https://search.nixos.org/packages
    home.packages = with pkgs; [
        # wl-clipboard
        # cliphist
        # grimblast
        # wofi
        # waybar
        # ssh
        firefox
        gnumake
        graphviz
        libimobiledevice
        valgrind
        evince
        gdb
        dconf-editor

        (pkgs.writeShellScriptBin "ide" (builtins.readFile ./scripts/ide.sh))
        (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh))
        
        
    ] ++ 
    (if config.raph.hostType == "desktop" then [ pkgs.heroic ] else []);




programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (_: projectSituations.minimal.packages);

    profiles.default = {
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;
        enableUpdateCheck = false;

        # The extensions Visual Studio Code should be started with
        extensions = projectSituations.minimal.extensions;
      
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
        userMcp = {};
        # Configuration written to Visual Studio Code's settings.json
        userSettings = import ./vscode/settings.nix;
        # Configuration written to Visual Studio Code's tasks.json
        userTasks = {};
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
