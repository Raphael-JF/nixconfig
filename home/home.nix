{ config, pkgs, lib, ... }:


{

    
home-manager.users.raph = {
    imports = [
        ./gnome.nix
    ];

    home.username = "raph";
    home.homeDirectory = "/home/raph";

    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        matchBlocks = {

            "enseirb" = {
            hostname = "ssh.enseirb-matmeca.fr";
            user = "rjontef";
            identityFile = "~/.ssh/laptop";
            addKeysToAgent = "yes";
            forwardAgent = true;
            };

            "almapedago travail64" = {
            user = "rjontef";
            proxyJump = "enseirb";
            };

            "thor thor.enseirb-matmeca.fr" = {
            hostname = "thor.enseirb-matmeca.fr";
            identityFile = "~/.ssh/laptop";
            identitiesOnly = true;
            addKeysToAgent = "yes";

            };

            "github.com" = {
            user = "git";
            identityFile = "~/.ssh/laptop";
            identitiesOnly = true;
            addKeysToAgent = "yes";

            };

        };
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
        firefox
        texliveFull
        clang-tools
        bear
    ];

programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default = {
        enableExtensionUpdateCheck = false;
        enableMcpIntegration = false;
        enableUpdateCheck = false;

        # The extensions Visual Studio Code should be started with
        extensions = [
            # --- Nix ---
            pkgs.vscode-extensions.bbenoist.nix


            # --- Python ---
            pkgs.vscode-extensions.ms-python.python
            pkgs.vscode-extensions.ms-python.vscode-pylance

            # --- Debug JS ---
            pkgs.vscode-extensions.ms-vscode.js-debug

            # --- UI ---
            pkgs.vscode-extensions.usernamehw.errorlens
            
            # pkgs.vscode-extensions.github.copilot-chat

            pkgs.vscode-extensions.llvm-vs-code-extensions.vscode-clangd



            (pkgs.vscode-utils.buildVscodeExtension {
                pname = "github-copilot-chat";
                version = "0.40.0";

                vscodeExtUniqueId = "GitHub.copilot-chat";
                vscodeExtPublisher = "GitHub";
                vscodeExtName = "copilot-chat";
                vscodeExtVersion = "0.40.0";

                src = pkgs.fetchurl {
                    url = "https://github.com/microsoft/vscode-copilot-chat/releases/download/v0.40.0/GitHub.copilot-chat.0.40.0.universal.vsix";
                    sha256 = "sha256-7iFLGF9lVNZDXnrJjoXdYz7gA6YDLciwZf4/lF8sYu4=";
                };
            })

            # --- C / C++ ---
            
            # (pkgs.vscode-utils.buildVscodeExtension {
            #     pname = "vscode-clangd";
            #     version = "0.4.0";

            #     src = pkgs.fetchurl {
            #     url = "https://open-vsx.org/api/llvm-vs-code-extensions/vscode-clangd/0.4.0/file/llvm-vs-code-extensions.vscode-clangd-0.4.0.vsix";
            #     sha256 = "sha256-r71PACuJZBASsWYFHKoq8vVu1zK32/S8AKVtCJHkGqk=";
            #     };

            #     vscodeExtPublisher = "llvm-vs-code-extensions";
            #     vscodeExtName = "vscode-clangd";
            #     vscodeExtUniqueId = "llvm-vs-code-extensions.vscode-clangd";
            # })

            (pkgs.vscode-utils.buildVscodeExtension {
                pname = "vscode-direnv";
                version = "1.0.0";

                src = pkgs.fetchurl {
                    url = "https://open-vsx.org/api/cab404/vscode-direnv/1.0.0/file/cab404.vscode-direnv-1.0.0.vsix";
                    sha256 = "sha256-+nLH+T9v6TQCqKZw6HPN/ZevQ65FVm2SAo2V9RecM3Y=";
                };

                vscodeExtPublisher = "cab404";
                vscodeExtName = "vscode-direnv";
                vscodeExtUniqueId = "cab404.vscode-direnv";
            })
        ];
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
