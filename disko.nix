{
    device ? throw "Set this to your disk device, e.g. /dev/sda",
}: {
    disko.devices = {
        disk.main = {
            inherit device;
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
                    crypt-main = {
                        size = "100%";
                        content = {
                            type = "luks";
                            name = "crypt-main";
                            content = {
                                type = "lvm_pv";
                                vg = "main";
                            };
                            settings = {
                                bypassWorkqueues = true;
                                allowDiscards = true;
                                crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
                            };
                        };
                    };
                };
            };
        };

        lvm_vg.main.lvs = {
            nix.size = "100G";
            persist.size = "100G";
            swap = {
                size = "30G";
                lvm_type = "thinlv";
                pool = "thin-main";
                content = {
                    type = "swap";
                    randomEncryption = true;
                };
            };
            crypt-home-someuser = {
                size = "100G";
                lvm_type = "thinlv";
                pool = "thin-main";
                content = {
                    type = "luks";
                    name = "home-someuser";
                    content = {
                        type = "filesystem";
                        format = "btrfs";
                        mountOptions = [ "noatime" ];
                    };
                };
            };
        };
    };
}
