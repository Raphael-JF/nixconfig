{ pkgs, ... }:
{
  services.usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
  };
  # Support du montage automatique via GVfs (Nautilus/Files verra l'iPhone comme un périphérique)
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice   # bibliothèque de base : pairing, infos device, communication
    ifuse              # monter le stockage de l'iPhone (photos, DCIM) via FUSE
    idevicerestore     # restauration/flash firmware (avancé, à utiliser avec prudence)
    ideviceinstaller   # installer/lister/désinstaller des apps .ipa
  ];
}
