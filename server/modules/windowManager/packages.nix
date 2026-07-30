{ pkgs, ... }:
{ 
  environment.systemPackages = with pkgs; [
   firefox
   chromium
   wl-clipboard
   evince
   anki-bin
];
}
