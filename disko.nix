{
    device ? throw "Set this to your disk device, e.g. /dev/sda",
           ...
}: {
    disko.devices = {
        disk.main = {
            inherit device;
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    esp = {
                        name = "ESP";
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
                                allowDiscards = true;
                                keyFile = "/tmp/secret.key";
                            };
                            content = {
                                type = "btrfs";
                                extraArgs = ["-f"];

                                subvolumes = {
                                    "/root" = {
                                        mountpoint = "/";
                                    };
                                    "/persist" = {
                                        mountOptions = ["subvol=persist" "noatime"];
                                        mountpoint = "/persist";
                                    };
                                    "/nix" = {
                                        mountOptions = ["subvol=nix" "noatime"];
                                        mountpoint = "/nix";
                                    };
                                    "/swap" = {
                                        mountpoint = "/.swapvol";
                                        swap.swapfile.size = "4G";
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
