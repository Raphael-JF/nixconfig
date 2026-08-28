
{ lib, pkgs, ... }:
{
  imports = [
    ../../windowManager
    

    ./jackFix.nix
    ./switchOutput.nix
  ];
  config = {

    systemd.services.display-manager.wantedBy = lib.mkForce []; # prevent GDM (windows manager) from starting on boot
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "raph"; 

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "tvToggle" ''
        if systemctl is-active --quiet display-manager; then
          exec sudo ${pkgs.systemd}/bin/systemctl stop display-manager
        else
          exec sudo ${pkgs.systemd}/bin/systemctl start display-manager
        fi
      '')
    ]; 
    security.sudo.extraRules = [
      {
        users = [ "raph" ];
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl start display-manager";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl stop display-manager";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    environment.etc."xdg/autostart/firefox.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Firefox
      Exec=${pkgs.firefox}/bin/firefox
      X-GNOME-Autostart-enabled=true
    '';
  };
}
