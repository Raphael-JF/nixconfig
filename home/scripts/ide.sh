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
exec nix run ".#$name" -- "$path"