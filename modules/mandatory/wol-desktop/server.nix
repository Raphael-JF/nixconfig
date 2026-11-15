{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.wakeonlan
    (pkgs.writeShellScriptBin "desktop-boot" ''
      set -e

      wakeonlan "18:c0:4d:a3:ec:41"

      echo "Booting desktop."
    '')
  ];
}
