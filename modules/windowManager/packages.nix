{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
    wl-clipboard
    evince
    baobab
    nautilus
    gnome-disk-utility
    (pkgs.totem.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      substituteInPlace $out/share/applications/org.gnome.Totem.desktop \
        --replace-fail 'Exec=totem %U' 'Exec=env GDK_BACKEND=x11 totem %U' \
        --replace-fail 'DBusActivatable=true' 'DBusActivatable=false'
    '';
    }))
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
