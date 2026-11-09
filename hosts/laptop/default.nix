{ hostname , pkgs, ... }:
{  
  imports = [
    ./hardware-configuration.nix 
    ./disko.nix

    ../../modules
  ];

  # run kitty at startup
  environment.etc."xdg/autostart/kitty.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Kitty
    Exec=${pkgs.kitty}/bin/kitty
    X-GNOME-Autostart-enabled=true
  '';

  
  # moonlight to stream games from my desktop to my laptop
  environment.systemPackages = with pkgs; [
    moonlight-qt
  ];

  system.stateVersion = "26.05";
}
