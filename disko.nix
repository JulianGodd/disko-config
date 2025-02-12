{
    device ? throw "Set this to your disk device, e.g. /dev/sda",
}: {
    disko.devices = {
        disk.main = {
            inherit device;
            content.partitions = {
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
}
