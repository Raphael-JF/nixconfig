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
          port = 444;
          protocol = "tcp";
          filter = "nextcloud";
          maxretry = 4;
          bantime = 86401;
          findtime = 43201;
        };
      };
    };

  environment.etc = {
  "fail2ban/filter.d/nextcloud.local".text = pkgs.lib.mkDefault ''
    [Definition]
    failregex = ^.*"remoteAddr":"<HOST>".*"message":"Login failed:
                ^.*"remoteAddr":"<HOST>".*"message":"Two-factor challenge failed:
                ^.*"remoteAddr":"<HOST>".*"message":"Trusted domain error.
  '';
};
}
