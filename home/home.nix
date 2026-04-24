{ config, pkgs, lib, ... }:


let
    projectSituations = import ./vscode/make-codium/project-situations.nix { inherit pkgs; };
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
        IdentityFile ~/.ssh/laptop
        AddKeysToAgent yes
        ForwardAgent yes

        Host almapedago travail64
        User rjontef
        ProxyJump enseirb

        Host thor thor.enseirb-matmeca.fr
        HostName thor.enseirb-matmeca.fr
        IdentityFile ~/.ssh/laptop
        IdentitiesOnly yes
        AddKeysToAgent yes

        Host github.com
        User git
        IdentityFile ~/.ssh/laptop
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

    programs.git = {
        enable = true;
        settings = {
            user = {
                userName = "Raphaël Jontef";
                userEmail = "raphael.jontef@enseirb-matmeca.fr";
            };
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
        texliveFull
        gnumake
        graphviz
        libimobiledevice
        valgrind
        evince
        gdb
        dconf-editor

    ];

programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
};

programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhsWithPackages (_: projectSituations.full.packages);

    profiles.default = {
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;
        enableUpdateCheck = false;

        # The extensions Visual Studio Code should be started with
        extensions = projectSituations.full.extensions;
        # ++
        # (pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        #     # {
        #     # name = "copilot";
        #     # publisher = "GitHub";
        #     # version = "1.388.0";
        #     # sha256 = "sha256-qo+vuqdnKhZAbPVEXxdmAnGyfDE/bPfiiCbM1HapPFM=";
        #     # }
        #     {
        #     name = "copilot-chat";
        #     publisher = "GitHub";
        #     version = "0.40";
        #     sha256 = "sha256-eX3Id56jxPp8pHD0C8JvRIqdTRdc6+ScrP35hy39nB4=";
        #     }
        # ]);
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


programs.bash = {
    enable = true;
    initExtra = ''
        rebuild() {
        cd ~/Desktop/nixconfig
        git pull && sudo nixos-rebuild switch --flake ~/Desktop/nixconfig#$1
        }
    '';
};
    

    # wayland.windowManager.hyprland = {
    #     settings = import ./hyprland/hyprland.nix;
    #     enable = false;
    #     systemd.enable = false;
    # };
    home.stateVersion = "25.11";
};
}
