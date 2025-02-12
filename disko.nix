{
    device ? throw "Set this to your disk device, e.g. /dev/sda",
           ...
}: {
    disko.devices = {
        disk = {
            main = {
                inherit device;
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "512M";
                            type = "EF00";
                            content = {
                                type = "filesystem";
                                format = "vfat";
                                mountpoint = "/boot";
                                mountOptions = [ "umask=0077" ];
                            };
                        };
                        luks = {
                            size = "100%";
                            content = {
                                type = "luks";
                                name = "crypted";
                                settings = {
                                    bypassWorkqueues = true;
                                    allowDiscards = true;
                                    keyFile = "/tmp/secret.key";
                                    crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
                                };
                                content = {
                                    type = "btrfs";
                                    extraArgs = [ "-f" ];
                                    subvolumes = {
                                        "/root" = {
                                            mountpoint = "/";
                                        };
                                        "/persist" = {
                                            mountpoint = "/persist";
                                            mountOptions = [ "subvol=persist" "compress=zstd" "noatime" ];
                                        };
                                        "/nix" = {
                                            mountpoint = "/nix";
                                            mountOptions = [ "subvol=nix" "compress=zstd" "noatime" ];
                                        };
                                        "/swap" = {
                                            mountpoint = "/.swapvol";
                                            swap.swapfile.size = "8G";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
        };
    };
}
}
