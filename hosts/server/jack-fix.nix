# prevent jack from disabling speakers.
{ pkgs, ... }:

let
  hda-jack-fix = pkgs.writeText "hda-jack-fix.fw" ''
    [codec]
    0x10ec0269 0x27821404 0

    [hint]
    jack_detect = no
  '';
in
{
  environment.systemPackages = [ pkgs.pulseaudio ];
  hardware.firmware = [ hda-jack-fix ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=hda-jack-fix.fw
  '';
}
