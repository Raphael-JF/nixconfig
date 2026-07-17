{
  pkgs,
  config,
  ...
}:

let
  script = pkgs.writeShellApplication {
    name = "update-public-ip";

    runtimeInputs = with pkgs; [
      curl
      git
      jq
    ];

    text = ''
      set -euo pipefail

      REPO=/var/lib/public-ip
      FILE=$REPO/ip.txt

      cd "$REPO"

      NEW_IP=$(curl -fsSL https://api.ipify.org)

      OLD_IP=""

      if [ -f "$FILE" ]; then
          OLD_IP=$(cat "$FILE")
      fi

      if [ "$NEW_IP" = "$OLD_IP" ]; then
          exit 0
      fi

      echo "$NEW_IP" > "$FILE"

      git add ip.txt
      git commit -m "Update IP: $NEW_IP"
      git push
 echo "Nouvelle IP : $NEW_IP"
echo "Ancienne IP : $OLD_IP"

if [ "$NEW_IP" = "$OLD_IP" ]; then
    echo "Aucun changement."
    exit 0
fi

echo "IP modifiée, push sur GitHub..."   '';
  };
in
{

  systemd.services.public-ip = {
    description = "Update public IP on GitHub";

    serviceConfig = {
      Type = "oneshot";
      User = "raph";
    };

    script = "${script}/bin/update-public-ip";
  };

  systemd.timers.public-ip = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "15min";
      Unit = "public-ip.service";
    };
  };

}
