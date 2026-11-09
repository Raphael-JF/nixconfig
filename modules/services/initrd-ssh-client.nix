{ perHost, pkgs, ...}:
{
  config = perHost {
    server = {
      environment.systemPackages = [
        (pkgs.writeShellScriptBin "desktop-boot" ''
          set -e

          DESKTOP="192.168.1.104"
          INITRD_PORT="2222"
          SSH_PORT="22"
          SSH_KEY="$HOME/.ssh/desktop-initrd"

          echo "Attempting SSH connection to desktop-initrd..."

          until nc -z "$DESKTOP" "$INITRD_PORT" 2>/dev/null; do
            sleep 2
          done

          echo "Initrd SSH is ready."

          ssh \
            -i "$SSH_KEY" \
            -p "$INITRD_PORT" \
            root@"$DESKTOP"

          echo
          echo "Successfully unlocked desktop."
          echo "Waiting for desktop SSH..."

          until nc -z "$DESKTOP" "$SSH_PORT" 2>/dev/null; do
            sleep 2
          done

          echo "Desktop is ready."
        '')
      ]; 
    }; 
  };
}
