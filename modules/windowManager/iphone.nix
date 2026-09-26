{ pkgs, ... }:
{
  services.usbmuxd = {
    enable = true;
  };

  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
    idevicerestore
    ideviceinstaller
  ];
  
  # To avoid waiting 90s for poweroff
  systemd.services.usbmuxd.serviceConfig.TimeoutStopSec = "1s";


  # work in progress
  # restart usbmuxd when an iPhone is connected to the system to avoid issues with iPhone enumeration
  systemd.services.usbmuxd-restart-on-iphone = {
    description = "Restart usbmuxd after iPhone USB enumeration";
    after = [ "usbmuxd.service" ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      ${pkgs.coreutils}/bin/sleep 2
      ${pkgs.systemd}/bin/systemctl restart usbmuxd.service
    '';
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05ac", TAG+="systemd", ENV{SYSTEMD_WANTS}="usbmuxd-restart-on-iphone.service"
  '';
}
