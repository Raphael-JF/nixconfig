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

  environment.etc = {
    # Adapted failregex for syslogs
    "fail2ban/filter.d/nextcloud.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Login failed:
                  ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Two-factor challenge failed:
                  ^.*"remoteAddr":"&lt;HOST&gt;".*"message":"Trusted domain error.
    '');
  };
}
