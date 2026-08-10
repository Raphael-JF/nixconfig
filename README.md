This is my NixOS configuration for both my laptop, my desktop and my server. They all share most of the configuration, which is why NixOS is pretty useful

To install the configuration, you can use the following command:
```bash

sudo nixos-rebuild switch --flake .#[laptop | desktop | server]
```
Once installed, a rebuild switch can be quickly triggered with:
```bash
    rebuild [laptop | desktop | server]
```

To first-install the configuration, you can use the following command on another machine while the target runs a SSH server:

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#hostname \
  --extra-files ./extra-files \
  root@<IP>
```
Where `hostname` is the hostname of the target machine, and `<IP>` is the IP address of the target machine. The `extra-files` directory contains any additional files that need to be copied over to the target machine during installation. At the moment, it only has to contain /etc/ssh/ssh_host_ed25519_key and /etc/ssh/ssh_host_ed25519_key.pub, which are the SSH host keys for the target machine. You can generate them with ` on the target machine before running the command.
