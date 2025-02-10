#!/usr/bin/env bash

curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/disko.nix -o /tmp/disko.nix

echo -n "Encryption Password: "
read pass
echo

echo -n "$pass" > /tmp/secret.key

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

sudo nixos-generate-config --no-filesystems --root /mnt

# Curl configuration and flake 

curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/nixos/configuration.nix -o /mnt/etc/nixos/configuration.nix
curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/nixos/flake.nix -o /mnt/etc/nixos/flake.nix

mv /tmp/disko.nix /mnt/etc/nixos/flake.nix

cd /mnt/etc/nixos

echo Change the username in configuration.nix and the drive in flake.nix, then run:
echo "    nixos-install --root /mnt --flake /mnt/etc/nixos#default"
