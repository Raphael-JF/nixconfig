{ pkgs, config, globals, ... }:

let
  keyfile = config.sops.secrets.desktop-root.path;
in
{
  environment.systemPackages = [
  (pkgs.writeShellScriptBin "desktop-unlock" ''
      set -eu
      if [ "$(id -u)" -ne 0 ]; then
        echo "Error: you must be root user." >&2
        exit 1
      fi
      DESKTOP="${globals.desktop.ip}"
      INITRD_PORT=2222

      echo "Waiting for desktop initrd SSH..."

      until ${pkgs.netcat-openbsd}/bin/nc -z "$DESKTOP" "$INITRD_PORT" 2>/dev/null; do
        sleep 2
      done

      echo "Sending LUKS key..."

      ${pkgs.openssh}/bin/ssh \
        -p "$INITRD_PORT" \
        -o BatchMode=yes \
        -o StrictHostKeyChecking=yes \
        root@"$DESKTOP" \
        'cryptsetup-askpass' < "${keyfile}"

      echo "Waiting for desktop SSH..."

      until ${pkgs.netcat-openbsd}/bin/nc -z "$DESKTOP" 22 2>/dev/null; do
        sleep 2
      done

      echo "Desktop boot completed."
    '')
  ];
}
