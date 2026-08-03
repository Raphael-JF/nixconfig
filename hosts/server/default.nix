{ ... }:

{
  imports = [

    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/core
     
    # services
    ../../modules/services/docker.nix
    ../../modules/services/publicIp.nix
    ../../modules/services/icloudBackup.nix
    #../../modules/services/forgejo.nix
  ];


  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22   # ssh
    ];
  };


  services.icloudBackup.instances = {
    raph = {
      appleID = "poweraphael2@gmail.com";
    };
  };

  
  sshServer.enable = true;

  system.stateVersion = "26.05";
}
