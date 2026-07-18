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
      set -euxo pipefail

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
      git config user.name "raph"
      git config user.email "ton-email-github@example.com"
      git commit -m "Update IP: $NEW_IP"
      eval "$(ssh-agent -s)"

ssh-add /home/raph/.ssh/server

echo "IP modifiée, push sur GitHub..."

      git push'';
  };
in
{

  systemd.services.public-ip = {
    description = "Update public IP on GitHub";

    serviceConfig = {
      Type = "oneshot";
      User = "raph";
  Environment = [
    "HOME=/home/raph"
    "GIT_SSH_COMMAND=ssh -i /home/raph/.ssh/server -o IdentitiesOnly=yes"
  ];
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
