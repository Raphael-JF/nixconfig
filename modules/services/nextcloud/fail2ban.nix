# fail2ban.nix
{ pkgs, lib, ... }:
{
  services.fail2ban = {
    enable = true;
    # Ref: https://docs.nextcloud.com/server/latest/admin_manual/installation/harden_server.html#setup-a-filter-and-a-jail-for-nextcloud
    jails = {
      nextcloud.settings = {
        backend = "systemd";
        journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";
        enabled = true;
        port = "http,https";
        filter = "nextcloud";
        maxretry = 4;
        bantime = 86401;
        findtime = 43201;
      };
    };
  };

  environment.etc."fail2ban/filter.d/nextcloud.local".text = lib.mkDefault ''
    [Definition]
    failregex = ^.*"remoteAddr":"<HOST>".*"message":"Login failed:
                ^.*"remoteAddr":"<HOST>".*"message":"Two-factor challenge failed:
                ^.*"remoteAddr":"<HOST>".*"message":"Trusted domain error.
  '';
}
