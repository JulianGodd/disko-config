{
    device ? throw "Set this to your disk device, e.g. /dev/sda",
           ...
}: {
    disko.devices = {
        disk = {
            main = {
                type = "disk";
                device = "/dev/vdb";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            size = "500M";
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
                                name = "crypt-main";
                                extraOpenArgs = [ ];
                                additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                                content = {
                                    type = "lvm_pv";
                                    vg = "pool";
                                };
                                settings = {
                                    bypassWorkqueues = true;
                                    keyFile = "/tmp/secret.key";
                                    allowDiscards = true;
                                    crypttabExtraOpts = [ "tpm2-device=auto" "tpm2-measure-pcr=yes" ];
                                };
                            };
                        };
                    };
                };
            };
        };
        lvm_vg = {
            pool = {
                type = "lvm_vg";
                lvs = {
                    thin-main = {
                        size = "95%FREE";
                        lvm_type = "thin-pool";
                    };
                    nix = {
                        lvm_type = "thinlv";
                        pool = "thin-main";
                        content = {
                            type = "filesystem";
                            format = "btrfs";
                            mountpoint = "/nix";
                            mountOptions = [ "noatime" ];
                        };
                    };
                    persist = {
                        lvm_type = "thinlv";
                        pool = "thin-main";
                        content = {
                            type = "filesystem";
                            format = "btrfs";
                            mountpoint = "/mnt/persist";
                            mountOptions = [ "noatime" ];
                        };
                    };
                };
            };
        };
    };
}
