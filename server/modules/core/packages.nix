{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [

    git

    neovim

    wget

    curl

    htop

    btop

    tree

    tmux

    unzip

    pciutils

    usbutils

    lsof
  ];
}
