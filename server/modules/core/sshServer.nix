{ lib, config, ... }:
{
  options.sshServer.enable = lib.mkEnableOption "Enable SSH server";

  config = lib.mkIf config.sshServer.enable {
    services.openssh = {
      enable = true;
      openFirewall = false; # We manage the firewall separately
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowAgentForwarding = false;
        AllowTcpForwarding = false;
      };
    };
  };
}
