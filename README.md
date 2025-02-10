# disko-config

## Quick install
```bash
curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/install.sh -o /tmp/install.sh
```

```bash
chmod +x /tmp/install.sh
```

## downloading disko.nix
```bash
curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/disko.nix -o /tmp/disko.nix
```
## Populate password for disko luks encryption
```bash
echo -n "password" > /tmp/secret.key
```

## disko formatting command
replace `'"/dev/nvme0n1"'` with your drive
```bash
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/disko.nix --arg device '"/dev/nvme0n1"'
```

## Generate HW config
```bash
sudo nixos-generate-config --no-filesystems --root /mnt
```

## initialize flake
```bash
nix flake init --template github:vimjoyer/impermanent-setup
```


## installing nixos
```bash
nixos-install --root /mnt --flake /mnt/etc/nixos#default
```
