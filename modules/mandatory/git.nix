{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.git
  ];


  environment.etc."gitconfig".text = ''
    [user]
        name = "Raphaël Jontef"
        email = "raphael.jontef@enseirb-matmeca.fr"

    [init]
        defaultBranch = main

    [pull]
        rebase = false

    [push]
        autoSetupRemote = true

    [core]
        excludesFile = /etc/gitignore
  '';

  environment.etc."gitignore".text = ''
      .clangd
      .clangd.local
      compile_commands.json
      .direnv
      *.idx
      .aider*

      # LaTeX / Texlab generated files
      *.aux
      *.log
      *.out
      *.toc
      *.lof
      *.lot
      *.fls
      *.fdb_latexmk
      *.synctex.gz
      *.bcf
      *.run.xml
      *.bbl
      *.blg
      *.nav
      *.snm
      *.vrb
  '';

}
