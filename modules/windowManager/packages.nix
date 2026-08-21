{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    wl-clipboard
    evince
    baobab
    nautilus
    gnome-disk-utility
    totem # video player
    loupe # image viewer


    ffmpegthumbnailer
    poppler
    gdk-pixbuf

    anki-bin
    firefox
    chromium
  ];
}
