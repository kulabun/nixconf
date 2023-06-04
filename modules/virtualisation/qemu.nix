{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.virtualisation'.qemu;
in {
  options.virtualisation'.qemu.enable = mkEnableOption "qemu";

  config = mkIf cfg.enable {
    boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
    boot.extraModprobeConfig =
      "options kvm_intel nested=1"; # enable nested virtualization

    users = {
      users.${user}.extraGroups = [ "libvirtd" ];
    };

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          ovmf.enable = true; # UEFI support for VMs
        };
        # onBoot = "ignore";
        # onShutdown = "shutdown";
      };
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      qemu
      nixos-shell
    ];
  };

}
