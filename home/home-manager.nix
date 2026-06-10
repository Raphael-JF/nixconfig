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
        chromium
        gnumake
        graphviz
        wl-clipboard
        gnomeExtensions.copyous
        libimobiledevice
        ifuse
        valgrind
        evince
        gdb
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
        elmPackages.nodejs
        treeSitter
        lynx
        xclip

        #latex
        texliveFull
        

        #for C development
        gcc
        gdb
        clang-tools

        # for nix development
        nil
        ];

        plugins = with pkgs.vimPlugins; [
        nvim-web-devicons
        mini-icons

        #color theme
        kanagawa-nvim

        plenary-nvim

        { plugin = indent-blankline-nvim;
          type = "lua";
          config = toLua ''
            require("ibl").setup()
          '';
        }

        {
            plugin = copilot-lua;
            type = "lua";
            config = ''
            require("copilot").setup({
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                accept = "<C-l>",
                next = "<C-j>",
                prev = "<C-k>",
                dismiss = "<C-h>",
                },
            },
            panel = { enabled = true },
            })
            '';
        }

        {
            plugin = sidekick-nvim;
            type = "lua";
            config = ''
                require("sidekick").setup({
                suggestions = {
                    enabled = true,
                    debounce = 300,
                    auto_trigger = true,
                },

                agent = {
                    enabled = false, -- important: on reste "light", pas agent lourd
                },

                ui = {
                    border = "rounded",
                },
                })

                -- Keymaps
                local map = vim.keymap.set

                -- accepter suggestion inline
                map("n", "<C-l>", function()
                    -- if there is a next edit, jump to it, otherwise apply it if any
                    if not require("sidekick").nes_jump_or_apply() then
                        return "<C-l>" -- fallback to normal tab
                    end
                end, { expr = true })

                -- refuser suggestion
                map("i", "<C-]>", function()
                require("sidekick").dismiss()
                end)

                -- demander une suggestion manuellement
                map("n", "<leader>as", function()
                require("sidekick").suggest()
                end)

                -- appliquer modifications proposées (multi-line / diff)
                map("n", "<leader>ae", function()
                require("sidekick").apply()
                end)
                '';
        }
        {
            type = "lua";
            plugin = nvim-lspconfig;
            config = toLuaFile ./nvim/plugin/lsp.lua;
        }
        {
            type = "lua";
            plugin = nvim-treesitter;
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
        cmp-buffer
        cmp-path
        cmp-nvim-lsp

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
            plugin = nvim-tree-lua;
            config = toLuaFile ./nvim/plugin/nvim-tree.lua;
        }
    ];

        withRuby = false;
        withPython3 = false;
        initLua = toLuaFile ./nvim/init.lua;

        
    };

    home.stateVersion = "25.11";
}
