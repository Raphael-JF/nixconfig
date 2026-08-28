{ pkgs, ... }:

let
  switchOutput = pkgs.writeShellApplication {
    name = "switch-sink";
    runtimeInputs = [ pkgs.pulseaudio ];

    text = ''
      set -euo pipefail

      case "''${1:-}" in
        headphone)
          pactl set-sink-port @DEFAULT_SINK@ analog-output-headphones
          ;;
        speaker)
          pactl set-sink-port @DEFAULT_SINK@ analog-output-speaker
          ;;
        *)
          echo "Usage: switchOutput {headphone|speaker}" >&2
          exit 1
          ;;
      esac
    '';
  };

 in
{
  environment.systemPackages = [
    switchOutput
 ];
}
