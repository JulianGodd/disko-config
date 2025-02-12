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
                                extraOpenArgs = [ ];
                                settings = {
                                    # if you want to use the key for interactive login be sure there is no trailing newline
                                    # for example use `echo -n "password" > /tmp/secret.key`
                                    keyFile = "/tmp/secret.key";
                                    allowDiscards = true;
                                    crypttabExtraOpts = [ "tpm2-device=auto" ];
                                };
                                content = {
                                    type = "lvm_pv";
                                    vg = "pool";
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
                    root = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/";
                            mountOptions = [
                                "defaults"
                            ];
                        };
                    };
                };
            };
        };
    };
}
