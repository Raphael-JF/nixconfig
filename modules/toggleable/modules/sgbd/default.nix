{pkgs, lib, ...}:
{
  users.groups.projet-sgbd = {};

  users.users.projet-sgbd = {
    isNormalUser = true;
    group = "projet-sgbd";
    home = "/data/projet-sgbd";
    createHome = true;

  openssh.authorizedKeys.keys = [
    (lib.strings.trim (builtins.readFile ../../../../public-ssh-keys/laptop.pub))
    (lib.strings.trim (builtins.readFile ../../../../public-ssh-keys/desktop.pub))
  ];
  };

  systemd.tmpfiles.rules = [
    "d /data/projet-sgbd/web 0755 projet-sgbd projet-sgbd -"
    "f /data/projet-sgbd/.deploy 0644 projet-sgbd projet-sgbd -"
  ];

  systemd.services.sgbd-deploy = {
    description = "Deploy SGBD website";

    path = [ pkgs.openssh ];

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      WorkingDirectory = "/srv/projet-sgbd/web";
    };
    unitConfig = {
      RequiresMountsFor = ["/data"];
    };

    script = ''
      sftp \
        -i /home/raph/.ssh/id_ed25519 \
        -o UserKnownHostsFile=/home/raph/.ssh/known_hosts \
        -o BatchMode=yes \
        -b - \
        rjontef@rjontef.zzz.bordeaux-inp.fr <<EOF
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
 
