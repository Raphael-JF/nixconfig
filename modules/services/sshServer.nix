{ config, hostname, lib, ... }:
{
  options.services.sshServer.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable the SSH server service.";
  };
  config = lib.mkIf config.services.sshServer.enable {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        22   # ssh
      ];
    };

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
        AllowTcpForwarding = true;
      };
    };
  };
}
