{ pkgs }:

{
  minimal = {
    extensions = [
      pkgs.vscode-extensions.bbenoist.nix
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
        pkgs.vscode-extensions.usernamehw.errorlens



    ];

    packages = [
        
    ];
  };

  c = {
    extensions = [
      pkgs.vscode-extensions.llvm-vs-code-extensions.vscode-clangd
    ];

    packages = [
      pkgs.clang-tools
      pkgs.gcc
      pkgs.bear
      pkgs.gsl
      pkgs.gsl.dev
    ];
  };


  python-algonum = {
    extensions = [
      pkgs.vscode-extensions.ms-python.python
      pkgs.vscode-extensions.ms-python.vscode-pylance
    ];

    packages = [
        (pkgs.python3.withPackages (python-pkgs: with python-pkgs; [
            numpy
            matplotlib
            scipy
        ]))
    ];
  };

  latex = {
    extensions = [

    ];
    
    packages = [
        pkgs.texliveFull
    ];
  };

  pio = {
    extensions = [

    ];
    
    packages = [
        pkgs.platformio
        pkgs.avrdude
    ];
  };
}

    