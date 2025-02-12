#!/usr/bin/env bash

read -sp "Encryption Password: " pass1 && echo
read -sp "Confirm Password: " pass2 && echo
if [ "$pass1" != "$pass2" ]
then
    echo -e "\nError: Passwords don't match!"
    exit
fi

read -ep "Drive to use: " drive_file
if [ ! -b $drive_file ]; then
   echo -e "\nError: Path does not contain block device"
   exit
fi

read -p "Username: " username
read -p "Hostname: " hostname
echo

read -rp "Wipe drive and install nix? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) ;;
    *) exit;;
esac

echo Doing install

echo -n "$pass1" > /tmp/secret.key

curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/disko.nix -o /tmp/disko.nix

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'

nixos-generate-config --no-filesystems --root /mnt

# Curl configuration and flake 

curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/nixos/configuration.nix | sed "s/machine-user/$username/g" | sed "s/machine-host/$hostname/g" > /mnt/etc/nixos/configuration.nix
curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/nixos/flake.nix | sed "s;/dev/vda;$drive_file;g" > /mnt/etc/nixos/flake.nix

cat /tmp/disko.nix | sed '/keyFile = "/d' > /mnt/etc/nixos/disko.nix

echo -e "\n\nChange the username in configuration.nix and the drive in flake.nix, then run:"
echo "sudo nixos-install --root /mnt --flake /mnt/etc/nixos#default"
