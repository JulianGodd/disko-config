{ config, pkgs, lib, ... }:
{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    boot.loader = { # Bootloader
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    boot.initrd = { # TPM
        systemd.enable = true;
        availableKernelModules = [ "tpm_crb"];
    };

    #boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    #environment.etc."crypttab.initramfs".text = ''
    #    root UUID="..." none tpm2-device=auto
    #'';

    users.users."someuser" = {
        isNormalUser = true;
        initialPassword = "1";
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

        packages = with pkgs; [
            neovim
            curl
        ];
    };

    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
            #PasswordAuthentication = false;
            PermitRootLogin = lib.mkForce "no";
            KbdInteractiveAuthentication = false;
            LoginGraceTime = 0; # regreSSHion fix
        };
    };

    nixpkgs.config.allowUnfree = true;

    nix = {
        settings.experimental-features = [ "nix-command" "flakes" ];

        gc = { # Cleanup old system generations after a month
            options = "--delete-older-than 31d";
            persistent = true;
            dates = "monthly";
            automatic = true;
        };
    };

    time.timeZone = "America/Denver";
    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver.enable = true;

    system.stateVersion = "24.05"; # Don't change this
}
