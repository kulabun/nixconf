# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "8821au" ];
  boot.extraModulePackages = with pkgs.linuxPackages; [ rtl8821au ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/80699c90-ce4e-4de6-b45f-9c75a484be4b";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-75e92035-b145-4814-a76d-6b5a998efaf5".device =
    "/dev/disk/by-uuid/75e92035-b145-4814-a76d-6b5a998efaf5";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/F9FC-489F";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f4u2u2u2.useDHCP = lib.mkDefault true;

  hardware = {
    video.hidpi.enable = lib.mkDefault true;
    opengl = {
      enable = true;
      extraPackages = [ pkgs.vaapiIntel ];
    };
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
