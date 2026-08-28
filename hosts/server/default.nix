{ pkgs, lib, ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix
    ./jack-fix.nix
    ../../modules/core
    ../../modules/dev
     
    # services
    ../../modules/services/publicIP
    ../../modules/services/icloudBackup
    ../../modules/services/backup.nix
    ../../modules/services/sshServer.nix
    ../../modules/services/homepage
    ../../modules/services/nextcloud
    ../../modules/services/tv.nix

    #../../modules/services/forgejo.nix
  ];
  
  services.homepage.enable = true;
  services.raphNextcloud.enable = true;
  services.sshServer.enable = true;
  services.publicIP.enable = true;
  services.backup = {
    enable = true;
    devices.backup = {
      device = "/dev/disk/by-id/usb-SMI_USB_DISK_KT202000000000001037-0:0-part1";
      path = "/mnt/backupUSB";
    };
    devices.data = {
      device = "/dev/disk/by-label/backupDisk";
      path = "/data"; 
    };
  };
  services.icloudBackup = {
    enable = true;
    instances.raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };


  environment.systemPackages = [
    pkgs.wakeonlan
    (pkgs.writeShellScriptBin "bootDesktop" ''
      set -e

      MAC="18:c0:4d:a3:ec:41"
      DESKTOP="192.168.1.104"
      INITRD_PORT="2222"
      SSH_PORT="22"
      SSH_KEY="$HOME/.ssh/desktop-initrd"

      wakeonlan "$MAC"

      echo "Booting desktop."
      echo "Attempting SSH connection to desktop-initrd..."

      until nc -z "$DESKTOP" "$INITRD_PORT" 2>/dev/null; do
        sleep 2
      done

      echo "Initrd SSH is ready."

      ssh \
        -i "$SSH_KEY" \
        -p "$INITRD_PORT" \
        root@"$DESKTOP"

      echo
      echo "Successfully unlocked desktop."
      echo "Waiting for desktop SSH..."

      until nc -z "$DESKTOP" "$SSH_PORT" 2>/dev/null; do
        sleep 2
      done

      echo "Desktop is ready."
    '')
  ];
  system.stateVersion = "26.05";
}
