#!/usr/bin/env bash
set -e

if [ "$#" -lt 1 ]; then
  echo "Usage: rebuild HOSTNAME"
  echo "HOSTNAME should be one of: desktop, laptop"
  exit 1
fi


cd ~/nixconfig
git pull && sudo nixos-rebuild switch --flake ~/nixconfig#$1 --impure