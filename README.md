This is my NixOS configuration for both my laptop, my desktop and my server. They all share most of the configuration, which is why NixOS is pretty useful

To install the configuration, you can use the following command:
```bash

sudo nixos-rebuild switch --flake .#[laptop | desktop | server]
```
Once installed, a rebuild can be quickly triggered with:
```bash
    rebuild [laptop | desktop | server]
```
