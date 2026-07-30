{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
   wl-clipboard
   evince
   baobab
   nautilus
   gnome-disk-utility

   anki-bin
   firefox
   chromium
];
}
