{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules/core
    ../../modules/osShared.nix

    ../../modules/dev
    ../../modules/windowManager
    ../../modules/services/sshServer.nix
    # ../../modules/services/airplay.nix
  ];
  services.sshServer.enable = true;
  packages.development.enable = true; 

  windowManager.osShared.device = "/dev/disk/by-uuid/726D-7F83";

  # run kitty at startup
  environment.etc."xdg/autostart/kitty.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Kitty
    Exec=${pkgs.kitty}/bin/kitty
    X-GNOME-Autostart-enabled=true
  '';


  # wireguard
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.2/24" ];

    privateKeyFile = "/etc/wireguard/private";

    peers = [{
      publicKey = "<CLE_PUBLIQUE_DU_SERVEUR>";
      allowedIPs = [ "10.100.0.1/32" ];
      endpoint = "<IP_PUBLIQUE_DU_SERVEUR>:51820";
      persistentKeepalive = 25;
    }];
  };



  system.stateVersion = "26.05";
}
