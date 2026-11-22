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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGIuWRGA9Rma+lM2gZBctPU3OkI6ds2fO/qEXuRGeMyb youssef@Youssefs-MacBook-Air.local"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJuqmMbLdDzezRUIfuOTQTI3KPsbCZyYERM0RrpDO/mS mhssassa@piano"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHqrpk1mazrvlYE3A36YqTD/5dxhu29HjyK7iDRr2LzP etiennedevergnette@MacBook-Air-de-Etienne.local"
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
      sftp -b - -J enseirb rjontef@rjontef.zzz.bordeaux-inp.fr <<EOF
      cd data/www
      put -R *
      EOF
    '';
  };

  systemd.paths.sgbd-deploy = {
    wantedBy = [ "multi-user.target" ];

    unitConfig = {
      DefaultDependencies = false;
      RequiresMountsFor = "/data/projet-sgbd/.deploy";
    };

    conflicts = [ "shutdown.target" ];
    before = [ "shutdown.target" ];

    pathConfig = {
      PathChanged = "/data/projet-sgbd/.deploy";
      Unit = "sgbd-deploy.service";
    };
  };
}
 
