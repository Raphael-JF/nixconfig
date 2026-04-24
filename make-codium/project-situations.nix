{ pkgs }:

{
  default = {
    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
    ];

    packages = [
    ];
  };

  c = {
    extensions = [
      pkgs.vscode-extensions.llvm-vs-code-extensions.vscode-clangd
      pkgs.vscode-extensions.bbenoist.nix
    ];

    packages = [
      pkgs.clang-tools
      pkgs.gcc
      pkgs.bear
      pkgs.gsl
      pkgs.gsl.dev
    ];
  };

  python = {
    extensions = [
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.vscode-pylance
    ];

    packages = [
    ];
  };

  full = {
    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.vscode-pylance
      pkgs.vscode-extensions.ms-vscode.js-debug
      pkgs.vscode-extensions.usernamehw.errorlens
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
    ];

    packages = [
      pkgs.clang-tools
      pkgs.gcc
      pkgs.bear
      pkgs.gsl
      pkgs.gsl.dev
    ];
  };
}