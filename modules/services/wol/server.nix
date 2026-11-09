{pkgs, ...}:
{
  environment.systemPackages = [
    pkgs.wakeonlan
    (pkgs.writeShellScriptBin "desktop-boot" ''
      set -e

      DESKTOP_MAC="18:c0:4d:a3:ec:41"

      wakeonlan "$DESKTOP_MAC"

      echo "Booting desktop."
    '')
  ];
}
