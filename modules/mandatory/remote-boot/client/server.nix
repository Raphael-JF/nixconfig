
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
    hostNames = [ "[192.168.1.104]:2222" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPskxztwa2wU6A0/0JOREun9fkDNFO2sGyI1q2d1xCAy root@raph-desktop";
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "desktop-unlock";

      runtimeInputs = with pkgs; [
        openssh
        netcat-openbsd
        coreutils
      ];

      text = ''
        if [[ $EUID -ne 0 ]]; then
          echo "Run as root." >&2
          exit 1
        fi

        DESKTOP="${desktopIP}"
        INITRD_PORT=2222
        SSH_PORT=22

        echo "Waiting for desktop initrd SSH..."

        until nc -z "$DESKTOP" "$INITRD_PORT" 2>/dev/null; do
          sleep 2
        done

        echo "Sending LUKS key..."

        # SSH peut être interrompu par le passage
        # de l'initrd au système réel.
        ssh -T \
          -v \
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
