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
            pkgs.nil
            pkgs.clang-tools
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
            indent-blankline-nvim
            #flash-nvim
            sidekick-nvim
            nvim-lspconfig 
            nvim-treesitter
            nvim-treesitter-textobjects
            lualine-nvim
            which-key-nvim
            nvim-cmp
            cmp-buffer
            cmp-path
            cmp-nvim-lsp
            #comment-nvim
            telescope-nvim
            nvim-tree-lua



        ];

        ###########################################################
        ## Configuration Lua
        ###########################################################

        luaRcContent = builtins.readFile ./init.lua;
      };
  };
}
