{ lib, config, hostname, ... }:
{
  options.services.sshServer.enable = lib.mkEnableOption "Enable SSH server";

  config = lib.mkIf config.services.sshServer.enable {
    services.openssh = {
      enable = true;
      openFirewall = false; # We manage the firewall separately
      hostKeys = [ {
        path = config.sops.secrets."ssh/${hostname}/private".path;
        type = "ed25519";
      } ];
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
