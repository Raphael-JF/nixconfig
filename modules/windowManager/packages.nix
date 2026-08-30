{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    wl-clipboard
    evince
    baobab
    nautilus
    gnome-disk-utility
    (pkgs.writeShellScriptBin "totem" ''
      exec env GDK_BACKEND=x11 ${pkgs.totem}/bin/totem "$@"
    '')
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
