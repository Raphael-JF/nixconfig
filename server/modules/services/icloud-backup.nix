{ pkgs, ... }:

let
  icloudBackup = pkgs.writeShellApplication {
    name = "icloud-backup";

    runtimeInputs = with pkgs; [
      icloudpd
    ];

    text = ''
      exec icloudpd   --directory ~/Photos --folder-structure "%Y/%m" --username poweraphael2@gmail.com
    '';
  };
in
{
  systemd.services.icloud-backup = {
    description = "Download iCloud Photos";

    serviceConfig = {
      Type = "oneshot";
      User = "raph";
    };

    path = [ pkgs.icloudpd ];

    script = ''
      ${icloudBackup}/bin/icloud-backup
    '';
  };

  systemd.timers.icloud-backup = {
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnBootSec = "10min";
      OnUnitActiveSec = "1h";
      Persistent = true;
    };
  };
}
