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
      .envrc
      *.idx
      .aider*
  '';

}
