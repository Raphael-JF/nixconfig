{ pkgs, ... }:

let
  tvSoundSwitchSpeaker = pkgs.writeShellScriptBin "tvSoundSwitchSpeaker" ''
    exec ${pkgs.pulseaudio}/bin/pactl set-sink-port @DEFAULT_SINK@ analog-output-speaker
  '';

  tvSoundSwitchHeadphone = pkgs.writeShellScriptBin "tvSoundSwitchHeadphone" ''
    exec ${pkgs.pulseaudio}/bin/pactl set-sink-port @DEFAULT_SINK@ analog-output-headphones
  '';

  tvSoundSwitchToggle = pkgs.writeShellScriptBin "tvSoundSwitchToggle" ''
    set -euo pipefail

    current="$(${pkgs.pulseaudio}/bin/pactl get-sink-port @DEFAULT_SINK@)"

    case "$current" in
      analog-output-speaker)
        exec ${tvSoundSwitchHeadphone}/bin/tvSoundSwitchHeadphone
        ;;
      analog-output-headphones)
        exec ${tvSoundSwitchSpeaker}/bin/tvSoundSwitchSpeaker
        ;;
      *)
        echo "Unknown current sink port: $current" >&2
        exit 1
        ;;
    esac
  '';
  tvToggle = pkgs.writeShellScriptBin "tvToggle" ''
    if systemctl is-active --quiet display-manager; then
      exec sudo ${pkgs.systemd}/bin/systemctl stop display-manager
    else
      exec sudo ${pkgs.systemd}/bin/systemctl start display-manager
    fi
  '';
  tvVolume = pkgs.writeShellScriptBin "tvVolume" ''
    wpctl set_volume @DEFAULT_AUDIO_SINK@ $1
  '';

in
{
  environment.systemPackages = [
    tvSoundSwitchSpeaker
    tvSoundSwitchHeadphone
    tvSoundSwitchToggle
    tvVolume
    tvToggle
  ];
}
