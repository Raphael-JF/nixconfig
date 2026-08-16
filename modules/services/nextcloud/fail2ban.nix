{ pkgs, ... }:
{
  services.fail2ban = {
    enable = true;
    # The jail file defines how to handle the failed authentication attempts found by the Nextcloud filter
    # Ref: https://docs.nextcloud.com/server/latest/admin_manual/installation/harden_server.html#setup-a-filter-and-a-jail-for-nextcloud
    jails = {
      nextcloud.settings = {
        # START modification to work with syslog instead of logile
        backend = "systemd";
        journalmatch = "SYSLOG_IDENTIFIER=Nextcloud";
        # END modification to work with syslog instead of logile
        enabled = true;
        port = 443;
        protocol = "tcp";
        filter = "nextcloud";
        maxretry = 3;
        bantime = 86400;
        findtime = 43200;
      };
    };
  };


  environment.etc."fail2ban/filter.d/nextcloud.local".text = ''
    [Definition]
    failregex = ^.*"remoteAddr":"<HOST>".*"message":"Login failed:.*$
                ^.*"remoteAddr":"<HOST>".*"message":"Two-factor challenge failed:.*$
                ^.*"remoteAddr":"<HOST>".*"message":"Trusted domain error.*$
  '';
}

