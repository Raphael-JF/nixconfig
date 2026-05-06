Pour charger la config :
```bash

sudo nixos-rebuild switch --flake .#raph-laptop
```

Pour reconstruire seulement Home Manager, maintenant que la config utilisateur est exposée en standalone :
```bash
home-manager switch --flake .#raph-laptop
```

Si la commande `home-manager` n'est pas installée sur ta machine, tu peux aussi lancer :
```bash
nix run github:nix-community/home-manager -- switch --flake .#raph-laptop
```

Lancer VSCodium avec des profils combinés (minimal est toujours inclus) :
```bash
ide
ide c
ide c python
```