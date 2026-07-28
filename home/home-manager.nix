{ pkgs, my-nvim, lib, raph, ... }:

let
    projectSituations = import ../make-codium/project-situations.nix { inherit pkgs; };
    treeSitter = pkgs.callPackage ./packages/tree-sitter.nix {};
    sshIdentity = if raph.hostType == "desktop" then "~/.ssh/desktop" else "~/.ssh/laptop";
in
{
    imports = [
        ./gnome.nix
    ];

    fonts.fontconfig.enable = true;

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

        Host almapedago travail64 deepeirb
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

        Host server 
        HostName 82.126.172.121
        User raph
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
    home.file.".config/monitors.xml" = lib.mkIf (raph.hostType == "desktop") {
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
            ".aider*"
        ];
    };

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        firefox
        chromium
        gnumake
        cmake
        bear
        graphviz
        wl-clipboard
        gnomeExtensions.copyous
        libimobiledevice
        ifuse
        valgrind
        evince
        gdb
        gcc
        dconf-editor
        anki-bin
        nerd-fonts.fira-code
        gh
        dejavu_fonts
        aider-chat
        fritzing
        (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
            numpy
            matplotlib
            scipy
            mip 
            highspy
            pyserial
        ]))
        
        platformio
        avrdude
        caneda
        my-nvim

        (pkgs.writeShellScriptBin "ide" (builtins.readFile ./scripts/ide.sh))
        (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh))
        (pkgs.writeShellScriptBin "detach" (builtins.readFile ./scripts/detach.sh))
    ] ++
    (if raph.hostType == "desktop" then [
        pkgs.heroic
        pkgs.discord
    ] else []);


    programs.kitty = {
        enable = true;
        extraConfig = ''
        confirm_os_window_close 0
        font_size 12
        font_family FiraCode\ Nerd\ Font
        sync_to_monitor no
        input_delay 0
        repaint_delay 1
        map ctrl+shift+n no_op
    '';
        
    };

    programs.yazi = {
        enable = true;
    };

    home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };


    programs.vscode = {
        enable = true;
        package = pkgs.vscodium.fhsWithPackages (_: projectSituations.minimal.packages);

        profiles.default = {
            enableExtensionUpdateCheck = false;
            enableMcpIntegration = false;
            enableUpdateCheck = false;

            extensions = projectSituations.minimal.extensions;
            globalSnippets = null;
            keybindings = import ./vscode/keybindings.nix;
            languageSnippets = {
                c = builtins.fromJSON (builtins.readFile ./vscode/snippets/c.json);
                latex = builtins.fromJSON (builtins.readFile ./vscode/snippets/latex.json);
            };
            userMcp = {};
            userSettings = import ./vscode/settings.nix;
            userTasks = {};
        };
    };

    
    home.stateVersion = "25.11";
}
