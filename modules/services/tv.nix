{ lib, pkgs, ... }:
{
  imports = [
    ../windowManager
  ];
  config = {

    systemd.services.display-manager.wantedBy = lib.mkForce []; # prevent GDM (windows manager) from starting on boot
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "raph";

    environment.systemPackages = with pkgs; [

      (writeShellScriptBin "tvStart" ''
        sudo systemctl start display-manager
      '')

      (writeShellScriptBin "tvStop" ''
        sudo systemctl stop display-manager
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
  };
}
