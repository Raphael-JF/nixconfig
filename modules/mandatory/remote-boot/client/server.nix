
{ pkgs, config, globals, ... }:

let
  desktopIP = globals.desktop.ip;
  keyfile = config.sops.secrets.desktop-root.path;
in
{
  sops.secrets.desktop-root = {
    sopsFile = ../../../../secrets/keys/desktop-root.key.enc;
    format = "binary";
    mode = "0400";
  };
  programs.ssh.knownHosts."desktop-initrd" = {
    hostNames = [ "[${globals.desktop.ip}]:2222" ];
    publicKey = (builtins.readFile ../../../../public-ssh-keys/desktop-initrd.pub);
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "desktop-boot";

      runtimeInputs = with pkgs; [
        openssh
        netcat-openbsd
        coreutils
        wakeonlan
      ];

      text = ''
        if [[ $EUID -ne 0 ]]; then
          echo "Run as root." >&2
          exit 1
        fi

        DESKTOP="${desktopIP}"
        INITRD_PORT=2222
        SSH_PORT=22


        wakeonlan "${globals.desktop.mac}"

        echo "Booting desktop."
        echo "Waiting for desktop initrd SSH..."

        until nc -z "$DESKTOP" "$INITRD_PORT" 2>/dev/null; do
          sleep 2
        done

        echo "Sending LUKS key..."

        # SSH peut être interrompu par le passage
        # de l'initrd au système réel.
        ssh -T \
          -i ~raph/.ssh/server \
          -p "$INITRD_PORT" \
          -o BatchMode=yes \
          -o StrictHostKeyChecking=yes \
          -o ConnectTimeout=10 \
          root@"$DESKTOP" \
          '
            set -eu
            umask 077

            mkdir -p /run/cryptsetup-keys.d

            cat > /run/cryptsetup-keys.d/cryptroot2.key

            systemctl restart systemd-cryptsetup@cryptroot2.service

            rm -f /run/cryptsetup-keys.d/cryptroot2.key
          ' < "${keyfile}" || {
            echo "SSH disconnected or unlock command failed."
          }

        echo "Waiting for desktop SSH..."

        attempt=0
        while (( attempt < 90 )); do
          if nc -z "$DESKTOP" "$SSH_PORT" 2>/dev/null; then
            echo "Desktop SSH is reachable."
            exit 0
          fi

          sleep 2
          (( attempt += 1 ))
        done

        echo "Timeout: desktop SSH not reachable." >&2
        exit 1
      '';
    })
  ];

}
