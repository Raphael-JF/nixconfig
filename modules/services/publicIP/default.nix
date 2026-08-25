{ pkgs, lib, config, hostname, ...} :
let
  script = pkgs.writeShellApplication {
    name = "updatePublicIP";

    runtimeInputs = with pkgs; [
      curl
      sshs
      git
      jq
    ];

    text = ''
      set -euxo pipefail

      REPO=/var/lib/publicIP
      FILE=$REPO/ip.txt
      REMOTE="git@github.com:Raphael-JF/publicIP.git"

      if [ ! -d "$REPO/.git" ]; then
          mkdir -p "$REPO"
          git clone "$REMOTE" "$REPO"
      fi

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

      echo "IP modifiée, push sur GitHub..."

      git push
    '';
  };
in

{
  imports = [ ./users.nix ];
  options.services.publicIP.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the public IP update service.";
  };

  config = lib.mkIf config.services.publicIP.enable {

    systemd.services.publicIP = {
      description = "Update public IP on GitHub";

      serviceConfig = {
        Type = "oneshot";
        User = "raph";
        StateDirectory = "publicIP";
        Environment = [
          "HOME=/home/raph"
          "GIT_SSH_COMMAND=ssh -i /home/raph/.ssh/${hostname} -o IdentitiesOnly=yes"
        ];
      };

      script = "${script}/bin/updatePublicIP";
    };

    systemd.timers.publicIP = {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "15min";
        Unit = "publicIP.service";
      };
    };
  };
}
