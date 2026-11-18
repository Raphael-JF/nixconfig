{pkgs, lib, ...}:
{
  users.groups.projet-sgbd = {};

  users.users.projet-sgbd = {
    isNormalUser = true;
    group = "projet-sgbd";
    home = "/data/projet-sgbd";
    createHome = false;

  openssh.authorizedKeys.keys = [
    (lib.strings.trim (builtins.readFile ../../../../public-ssh-keys/laptop.pub))
    (lib.strings.trim (builtins.readFile ../../../../public-ssh-keys/desktop.pub))
  ];
  };

  systemd.tmpfiles.rules = [
    "z /data/projet-sgbd 0755 projet-sgbd projet-sgbd -"
    "d /data/projet-sgbd/web 0755 projet-sgbd projet-sgbd -"
    "f /data/projet-sgbd/.deploy 0644 projet-sgbd projet-sgbd -"
  ];

  systemd.services.sgbd-deploy = {
    description = "Deploy SGBD website";

    path = [ pkgs.openssh ];

    unitConfig.RequiresMountsFor = [ "/data" ];

    serviceConfig = {
      Type = "oneshot";
      User = "raph";
      WorkingDirectory = "/data/projet-sgbd/web";
    };

    script = ''
      sftp -b - rjontef@rjontef.zzz.bordeaux-inp.fr -J enseirb<<EOF
      cd data/www
      put -R *
      EOF
    '';
  };

  systemd.paths.sgbd-deploy = {
    wantedBy = [ "multi-user.target" ];

    pathConfig = {
      PathChanged = "/data/projet-sgbd/.deploy";
      Unit = "sgbd-deploy.service";
    };
  };
}
 
