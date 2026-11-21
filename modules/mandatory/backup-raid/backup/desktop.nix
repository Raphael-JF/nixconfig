{ ... }:
{
  services.btrbk.sshAccess = [
    {
      key = (builtins.readFile ../../../../public-ssh-keys/server.pub);

      roles = [
        "target"
        "info"
        "receive"
        "delete"
      ];

      extraArgs = [
        "--restrict-path"
        "/backup/server-data"
      ];
    }
  ];

  security.sudo.extraRules = [
    {
      users = [ "raph" ];

      commands = [
        {
          command = "/run/current-system/sw/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
