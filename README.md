# disko-config

## Quick install
```bash
curl https://raw.githubusercontent.com/JulianGodd/disko-config/refs/heads/main/install.sh -o /tmp/install.sh && \
chmod +x /tmp/install.sh
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
