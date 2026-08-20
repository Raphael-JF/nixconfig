{ pkgs, ... }:
{
  
  services.fail2ban = {
    enable = true;
    # Ref: https://docs.nextcloud.com/server/latest/admin_manual/installation/harden_server.html#setup-a-filter-and-a-jail-for-nextcloud
    jails = {
      nextcloud.settings = {
        backend = "systemd";
        journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";
        enabled = true;
        port = "80,443";
        protocol = "tcp";
        filter = "nextcloud";
        maxretry = 3;
        bantime = 86400;
        findtime = 43200;
      };
    };
  };

  environment.etc."fail2ban/filter.d/nextcloud.conf".text = ''
    [Definition]
    failregex = ^.*"remoteAddr":"<HOST>".*"message":"Login failed:.*$
                ^.*"remoteAddr":"<HOST>".*"message":"Two-factor challenge failed:.*$
                ^.*"remoteAddr":"<HOST>".*"message":"Trusted domain error.*$
  '';
}
