{ pkgs, lib, raph, ... }:

let
    projectSituations = import ../make-codium/project-situations.nix { inherit pkgs; };
    sshIdentity = if raph.hostType == "desktop" then "~/.ssh/desktop" else "~/.ssh/laptop";
in
{
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
        ];
    };

    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        firefox
        gnumake
        graphviz
        libimobiledevice
        ifuse
        valgrind
        evince
        gdb
        dconf-editor
        anki-bin

        (pkgs.writeShellScriptBin "ide" (builtins.readFile ./scripts/ide.sh))
        (pkgs.writeShellScriptBin "rebuild" (builtins.readFile ./scripts/rebuild.sh))
    ] ++
    (if raph.hostType == "desktop" then [
        pkgs.heroic
        pkgs.discord
    ] else []);

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