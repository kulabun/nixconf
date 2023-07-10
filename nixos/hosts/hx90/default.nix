# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, lib
, inputs
, user
, stateVersion
, ...
}:
with lib;
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Bootloader.
  boot = {
    kernelModules = [ "kvm-amd" ];

    initrd = {
      # Setup keyfile
      secrets."/crypto_keyfile.bin" = null;

      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."luks-75e92035-b145-4814-a76d-6b5a998efaf5".device = "/dev/disk/by-uuid/75e92035-b145-4814-a76d-6b5a998efaf5";
    };

    extraModprobeConfig = ''
      alias pci:v000014C3d00000608sv*sd*bc*sc*i* mt7921e
    '';
  };

  # Decrypt second drive
  environment.etc."crypttab".text = ''
    ct2000mx500ssd1 /dev/disk/by-uuid/71d37ba8-f366-45a2-9a5f-2c1238cef11c /crypto_keyfile.bin
  '';
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/80699c90-ce4e-4de6-b45f-9c75a484be4b";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/F9FC-489F";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/0c3bca9a-037d-4990-aecb-943e5becd99b";
      fsType = "ext4";
    };
    "/root-drive" = {
      device = "/dev/disk/by-uuid/80699c90-ce4e-4de6-b45f-9c75a484be4b";
      fsType = "ext4";
    };
  };

  swapDevices = [ ];

  hardware' = {
    mt7921e.enable = true;
    rtl8821au.enable = true;
  };

  system' = {
    # network.bridge = {
    #   enable = true;
    #   externalInterface = "wlp3s0";
    # };
  };

  virtualisation' = {
    docker.enable = true;
    lxc.enable = true;
    qemu.enable = false;
  };

  services' = {
    openssh.enable = true;
    tailscale.enable = true;
    cloudflare-warp.enable = false;
  };

  desktop' = {
    kde.enable = true;
  };

  shell' = {
    awscli.enable = true;
    dev-tools.enable = true;
    gcloud.enable = true;
    gopass.enable = true;
    lorri.enable = true;
    rclone.enable = true;
    scripts.enable = true;

    # Do I even need these?
    other.enable = true;
    youtube-dl.enable = false;
  };

  programs' = {
    chrome.enable = true;
    firefox.enable = true;
    vivaldi.enable = false;
    easyeffects.enable = true;
    obs-studio.enable = true;
    vscode.enable = false;
    slack.enable = false;
    zoom-us.enable = true;
    libreoffice.enable = true;
    bitwarden.enable = true;
    jetbrains = {
      idea-community.enable = true;
    };

    webapps = {
      google-calendar.enable = true;
      google-docs.enable = true;
      google-drive.enable = true;
      google-keep.enable = true;
      google-mail.enable = true;
      google-meet.enable = true;
      google-photos.enable = true;
      messenger.enable = true;
      telegram.enable = true;
      whatsapp.enable = true;
      poe.enable = true;
      chatgpt.enable = true;
      youtube-music.enable = true;
    };

    kitty = {
      enable = false;
      font = {
        name = "SauceCodePro Nerd Font";
        size = 9;
      };
    };
    alacritty = {
      enable = true;
      font = {
        name = "SauceCodePro Nerd Font";
        size = 10;
      };
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f4u2u2u2.useDHCP = lib.mkDefault true;

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    # video.hidpi.enable = true;
    # cpu.amd.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  networking.hostName = "hx90"; # Define your hostname.

  # Enable the X11 windowing system.
  services.xserver.enable = true; # BUG: when removed cursor disappers in wayland
  services.xserver.videoDrivers = [ "amdgpu" ];
  #programs.sway.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.sshd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users = {
    users.${user}.extraGroups = [ ];
    defaultUserShell = pkgs.zsh;
    mutableUsers = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tcpdump

    # Hardware-related tools.
    sdparm
    hdparm
    smartmontools # for diagnosing hard disks
    usbutils # lsusb
    pciutils # lspci
    nvme-cli

    # gpu vaapi utils
    libva-utils
    glxinfo
    vdpauinfo

    procps # pgrep, pkill
    inxi # print devices and associated drivers: inxi -Fza
    pavucontrol # volume control
    pulseaudio
    libnotify # notify-send
    mpd

    # Other tools.
    unzip
    zip
    wget
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  system.stateVersion = stateVersion;
}
