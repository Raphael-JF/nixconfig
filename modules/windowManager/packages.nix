{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    wl-clipboard
    evince
    baobab
    nautilus
    gnome-disk-utility
    celluloid # video player

    ffmpegthumbnailer
    poppler
    gdk-pixbuf

    anki-bin
    firefox
    chromium
  ];
}
