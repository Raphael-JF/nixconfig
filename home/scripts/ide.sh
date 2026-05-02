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

# trie les presets pour garantir un nom d'environnement cohérent
IFS=$'\n' presets=($(sort <<<"${presets[*]}"))
unset IFS

# Construit le nom de l'environnement Nix
name=$(IFS=-; echo "${presets[*]}")

echo "Lancement de l'environnement Nix pour VSCodium avec les presets: $name"

# Exécute l'environnement Nix avec le chemin
local_vscodium_dir="$HOME/.local/share/make-codium/$name/VSCodium"
# codium_profile_global_storage="$codium_profile_user_dir/globalStorage"
# codium_profile_machine_id="$codium_user_data_dir/machineid"
# codium_profile_storage_json="$codium_profile_user_dir/storage.json"
# codium_profile_state_db="$codium_profile_user_dir/state.vscdb"
# codium_profile_state_db_backup="$codium_profile_user_dir/state.vscdb.backup"

local_vscodium_dir="$HOME/.local/share/make-codium/$name/VSCodium"
public_vscodium_dir="$HOME/.config/VSCodium"

mkdir -p "$local_vscodium_dir" "$local_vscodium_dir/User"

local_global_storage="$local_vscodium_dir/User/globalStorage"
local_machine_id="$local_vscodium_dir/machineid"
public_global_storage="$public_vscodium_dir/User/globalStorage"
public_machine_id="$public_vscodium_dir/machineid"

if [ -d "$public_global_storage" ]; then
  echo globalStorage trouvé dans le local $name, pas de copie nécessaire.
else
  echo "Aucun globalStorage trouvé dans le local $name, copie du globalStorage public vers le local."
    cp -r "$public_global_storage" "$local_global_storage"
fi

if [ -f "$public_machine_id" ]; then
  echo machineid trouvé dans le local $name, pas de copie nécessaire.
else
  echo "Aucun machineid trouvé dans le local $name, copie du machineid public vers le local."
    cp "$public_machine_id" "$local_machine_id"
fi



# Symlink for settings.json
ln -sf "$public_vscodium_dir/User/settings.json" "$local_vscodium_dir/User/settings.json"

# Symlink for keybindings.json
ln -sf "$public_vscodium_dir/User/keybindings.json" "$local_vscodium_dir/User/keybindings.json"

# Symlink for snippets
ln -sf "$public_vscodium_dir/User/snippets" "$local_vscodium_dir/User/snippets"

exec nix run ~/nixconfig/make-codium#$name -- --user-data-dir "$local_vscodium_dir" -- "$path"