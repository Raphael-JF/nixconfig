{ pkgs, config, globals, ... }:

let
  updateDuckDNS = pkgs.writeShellApplication {
    name = "update-duckdns";

    runtimeInputs = [ pkgs.curl ];

    text = ''
      TOKEN=$(cat "$CREDENTIALS_DIRECTORY/token")

      RESPONSE=$(curl -fsSL --get \
        --data-urlencode "domains=${globals.server-url}" \
        --data-urlencode "token=$TOKEN" \
        --data-urlencode "ip=" \
        https://www.duckdns.org/update)

      if [ "$RESPONSE" != "OK" ]; then
        echo "DuckDNS update failed: $RESPONSE" >&2
        exit 1
      fi

      echo "DuckDNS updated successfully."
    '';
  };
in
{
  sops.secrets.duckdns-token = {};

  systemd.services.duckdns = {
    description = "Update DuckDNS public IP";

    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "oneshot";
      DynamicUser = true;

      LoadCredential =
        "token:${config.sops.secrets.duckdns-token.path}";

      ExecStart = "${updateDuckDNS}/bin/update-duckdns";
    };
  };

  systemd.timers.duckdns = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "1min";
      OnUnitActiveSec = "5min";
      Unit = "duckdns.service";
    };
  };
}
