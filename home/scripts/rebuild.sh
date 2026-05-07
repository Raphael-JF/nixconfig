#!/usr/bin/env bash
set -e

usage() {
  echo "Usage: rebuild [--home] HOSTNAME"
  echo "HOSTNAME should be one of: desktop, laptop, raph-desktop, raph-laptop"
}

home_only=false

if [ "$1" = "--home" ]; then
  home_only=true
  shift
fi

if [ "$#" -ne 1 ]; then
  usage
  exit 1
fi

host="$1"
case "$host" in
  desktop)
    target="raph-desktop"
    ;;
  laptop)
    target="raph-laptop"
    ;;
  raph-desktop|raph-laptop)
    target="$host"
    ;;
  *)
    usage
    exit 1
    ;;
esac

flake_dir="$HOME/nixconfig"

cd "$flake_dir"
git pull

if [ "$home_only" = true ]; then
  nix run github:nix-community/home-manager -- switch --flake "$flake_dir#$target"
else
  sudo nixos-rebuild switch --flake "$flake_dir#$target" --impure
fi