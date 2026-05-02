#!/usr/bin/env bash
set -e

# Vérifie qu'au moins une option est fournie
if [ "$#" -lt 1 ]; then
  echo "Usage: ide <option1> [<option2> ...] [path]"
  exit 1
fi

# Le dernier argument est le chemin (s'il existe et est un dossier)
path="${@: -1}"
if [ ! -d "$path" ]; then
  path="."
  presets=("$@")
else
  presets=("${@:1:$#-1}")
fi

# Construit le nom de l'environnement Nix
name=$(IFS=-; echo "${presets[*]}")

# Exécute l'environnement Nix avec le chemin
local_vscodium_dir="$HOME/.local/share/make-codium/$name/VSCodium"
local_extensions_dir="$HOME/.local/share/make-codium/$name/extensions"

public_vscodium_dir="$HOME/.config/VSCodium"

mkdir -p "$local_vscodium_dir" "$local_vscodium_dir/User"

# Symlink for settings.json
ln -sf "$public_vscodium_dir/User/settings.json" "$local_vscodium_dir/User/settings.json"

# Symlink for keybindings.json
ln -sf "$public_vscodium_dir/User/keybindings.json" "$local_vscodium_dir/User/keybindings.json"

# Symlink for snippets
ln -sf "$public_vscodium_dir/User/snippets" "$local_vscodium_dir/User/snippets"

exec nix run ~/nixconfig/make-codium#$name -- --user-data-dir "$local_vscodium_dir" --extensions-dir "$local_extensions_dir" -- "$path"