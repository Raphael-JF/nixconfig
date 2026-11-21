{pkgs, ...}:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "desktop-reboot-windows" ''
      set -e
      ssh -t desktop 'sudo efibootmgr -n 0004 && sudo reboot' 
    '')
  ];
}
