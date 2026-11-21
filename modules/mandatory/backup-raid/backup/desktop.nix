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
}
