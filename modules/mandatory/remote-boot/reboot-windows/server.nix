{pkgs, ...}:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "desktop-reboot-windows" ''
      set -e
      ssh -t desktop 'sudo efibootmgr -n 0008 && sudo reboot' 
    '')
  ];
}
