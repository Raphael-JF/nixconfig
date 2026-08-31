{
  description = "Raphael's Neovim";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
    };
  in {
    packages.${system}.default =
      pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {

        ###########################################################
        ## Runtime tools disponibles dans Neovim
        ###########################################################

        wrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          (pkgs.lib.makeBinPath [
            pkgs.git
            pkgs.ripgrep
            pkgs.fd
            pkgs.elmPackages.nodejs
            pkgs.tree-sitter
            pkgs.lynx
            pkgs.xclip
            pkgs.tmux
            pkgs.lsof
            pkgs.ast-grep
            pkgs.nerd-fonts.fira-code
         ])
        ];

        ###########################################################
        ## Plugins
        ###########################################################

        plugins = with pkgs.vimPlugins; [
            nvim-web-devicons
            mini-icons
            kanagawa-nvim #color theme
            plenary-nvim
            bufferline-nvim
            flash-nvim
            copilot-lsp
            sidekick-nvim
            nvim-lspconfig 
            nvim-treesitter
            nvim-treesitter-textobjects
            nvim-tree-lua
            lualine-nvim
            which-key-nvim
            nvim-cmp
            cmp-buffer
            cmp-path
            cmp-nvim-lsp
            comment-nvim
            snacks-nvim
            vim-visual-multi
            grug-far-nvim
            mini-surround
            




        ];

        ###########################################################
        ## Configuration Lua
        ###########################################################

        luaRcContent = ''
          vim.opt.rtp:prepend "${./.}"
          require("init")
        '';   
    };
  };
}
