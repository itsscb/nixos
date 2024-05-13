#!/usr/bin/env bash

if [ -z "$1"]
  then
    file='configuration.nix'
  else
    file=$1
fi

# cd to your config dir
cd /etc/nixos/

# Edit your config
sudo hx $(fd $file . --max-results=1 -E hardware-configuration.nix -e nix)

# Early return if no changes were detected (thanks @singiamtel!)
if sudo git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    cd -
    exit 0
fi

sudo rm nixos-switch.log

# A rebuild script that commits on a successful build
set -e

# Autoformat your nix files
sudo alejandra . &>/dev/null \
  || ( sudo alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
sudo git diff -U0 '*.nix'

echo -n "NixOS - Testing new configuration..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild dry-build &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

echo -e ': Test passed. Adding files to git'
sudo git add *

echo -n "NixOS - Rebuilding..."
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && sudo git restore --staged ./**/*.nix && cd - && exit 1)

echo -e ": Rebuild successful. Committing changes..."
# Get current generation metadata
current=$(nixos-rebuild list-generations --json | jq '.[0]')

echo -e ": $current"
# Commit all changes witih the generation metadata
sudo git commit -am "$current"

echo -e "NixOS - New Build commited as $current"
cd -
