{ pkgs, ... }:

let
  tvSoundSwitchSpeaker = pkgs.writeShellScriptBin "tvSoundSwitchSpeaker" ''
    exec ${pkgs.pulseaudio}/bin/pactl set-sink-port @DEFAULT_SINK@ analog-output-speaker
  '';

  tvSoundSwitchHeadphone = pkgs.writeShellScriptBin "tvSoundSwitchHeadphone" ''
    exec ${pkgs.pulseaudio}/bin/pactl set-sink-port @DEFAULT_SINK@ analog-output-headphones
  '';

  tvSoundSwitchToggle = pkgs.writeShellScriptBin "tvSoundSwitchToggle" ''
  case "$(${pkgs.pulseaudio}/bin/pactl list sinks | grep 'Active Port')" in
    *analog-output-speaker*)
      exec tvSoundSwitchHeadphone
      ;;
    *analog-output-headphones*)
      exec tvSoundSwitchSpeaker
      ;;
  esac
''; 
  tvToggle = pkgs.writeShellScriptBin "tvToggle" ''
    if ${pkgs.systemd}/bin/systemctl is-active --quiet display-manager; then
      exec sudo ${pkgs.systemd}/bin/systemctl stop display-manager
    else
      exec sudo ${pkgs.systemd}/bin/systemctl start display-manager
    fi
  '';
  tvVolume = pkgs.writeShellScriptBin "tvVolume" ''
    wpctl set-volume @DEFAULT_AUDIO_SINK@ $1
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
