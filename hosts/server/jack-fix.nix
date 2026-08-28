# prevent jack from disabling speakers.
{ pkgs, ... }:

let
  hda-jack-fix = pkgs.runCommand "hda-jack-fix" {} ''
    mkdir -p $out/lib/firmware
    cat > $out/lib/firmware/hda-jack-fix.fw <<'EOF'
    [codec]
    0x10ec0269 0x27821404 0

    [hint]
    jack_detect = no
    EOF
  '';
in
{
  environment
  hardware.firmware = [
    hda-jack-fix
  ];

  boot.extraModprobeConfig = ''
    options snd-hda-intel patch=hda-jack-fix.fw
  '';
}
