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


    ffmpegthumbnailer # minitatures for videos
    poppler # miniatures for pdfs
    gdk-pixbuf # minituares for images
    nextcloud-client

    anki-bin
    firefox
    chromium
  ];
}
