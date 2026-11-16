{pkgs, globals, ...}:
{
  environment.systemPackages = [
    pkgs.wakeonlan
    (pkgs.writeShellScriptBin "desktop-boot" ''
      set -e

      wakeonlan "${globals.desktop.mac}"

      echo "Booting desktop."
    '')
  ];
}
