#!/usr/bin/env bash

curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/disko.nix -o /tmp/disko.nix

read pass

echo this is \"$pass\"

echo -n "$pass" > /tmp/secret.key

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

sudo nixos-generate-config --no-filesystems --root /mnt
