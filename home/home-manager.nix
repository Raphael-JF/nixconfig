{ pkgs, lib, raph, ... }:

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
        nerd-fonts.fira-code
        treeSitter


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
    '';
        
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

    programs.neovim = 
    let
        toLua = str: "\n${str}\n";
        toLuaFile = file: "\n${builtins.readFile file}\n";
    in
    {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        extraPackages = with pkgs; [
        # for vim usage
        ripgrep
        fd
        

        #for C development
        gcc
        gdb
        clang-tools

        # for nix development
        nil
        ];

        plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-web-devicons
        mini-icons
        tokyonight-nvim

        {
            type = "lua";
            plugin = nvim-treesitter.withAllGrammars;
            config = toLuaFile ./nvim/plugin/treesitter.lua;
        }
        nvim-treesitter-textobjects
        {
           type = "lua";
           plugin = lualine-nvim;
            config = toLua ''
                require("lualine").setup()
            '';
        }
        {
            type = "lua";
            plugin = which-key-nvim;
            config = toLua ''
                require("which-key").setup()
            '';
        }
        {
            type = "lua";
            plugin = nvim-cmp;
            config = toLuaFile ./nvim/plugin/cmp.lua;
        }

        {
            type = "lua";
            plugin = comment-nvim;
            config = toLua ''
                require("Comment").setup()
            '';
        }

        {
            type = "lua";
            plugin = telescope-nvim;
            config = toLuaFile ./nvim/plugin/telescope.lua;
        }
        {
            type = "lua";
            plugin = persistence-nvim;
            config = toLua ''
                require("persistence").setup()
            '';
        }
    ];

        withRuby = false;
        withPython3 = false;
        initLua = toLuaFile ./nvim/init.lua;

        
    };

    home.stateVersion = "25.11";
}
