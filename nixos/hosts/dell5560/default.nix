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
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-cpu-intel-kaby-lake
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
      luks.devices."luks-8f93d47d-b02f-48ca-acb4-011ff2756e8f".device = "/dev/disk/by-uuid/8f93d47d-b02f-48ca-acb4-011ff2756e8f";

      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };

      # Enable swap on luks
      luks.devices."luks-84466a7a-bf3c-47b1-9a42-2d12d1288a23".device = "/dev/disk/by-uuid/84466a7a-bf3c-47b1-9a42-2d12d1288a23";
      luks.devices."luks-84466a7a-bf3c-47b1-9a42-2d12d1288a23".keyFile = "/crypto_keyfile.bin";
    };
    # kernelModules = [ "kvm-intel" "nvidia" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9dd9bfed-c126-4c12-9148-18ad5ba20836";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3788-DEA3";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/4b9fc722-9c93-4917-a594-84ef4482b1f4"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "dell5560";

  system' = {
    # network.bridge = {
    #   enable = true;
    #   externalInterface = "wlp2s0";
    # };
  };

  virtualisation' = {
    docker.enable = true;
    lxc.enable = true;
  };

  services' = {
    openssh.enable = true;
    tailscale.enable = true;
    cloudflare-warp.enable = true;
  };

  desktop' = {
    kde.enable = true;
  };

  shell' = {
    awscli.enable = true;
    dev-tools.enable = true;
    scripts.enable = true;
    lorri.enable = true;
    gopass.enable = true;
    youtube-dl.enable = true;
    other.enable = true;
  };

  programs' = {
    bitwarden.enable = true;
    brave.enable = false;
    chrome.enable = true;
    easyeffects.enable = true;
    libreoffice.enable = true;
    obs-studio.enable = true;
    slack.enable = true;
    spotify.enable=true;
    vivaldi.enable = false;
    vscode.enable = false;
    yubikey.enable = true;
    zoom-us.enable = true;
    jetbrains = {
      idea-community.enable = true;
    };

    webapps = {
      # google-calendar.enable = true;
      # google-docs.enable = true;
      # google-drive.enable = true;
      # google-keep.enable = true;
      # google-mail.enable = true;
      # google-meet.enable = true;
      # google-photos.enable = true;
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

  work' = {
    lxc.enable = true;
    sops.enable = true;
    mongodb-compass.enable = true;

    # Deprecated
    globalprotect-vpn.enable = false;

    # I keep seeing firefox browser crashing. Sometimes once a day, sometimes once an hour. I need a stable browser
    firefox.enable = false;
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0f4u2u2u2.useDHCP = lib.mkDefault true;

  hardware = {
    # nvidia = {
    #   # Modesetting is required.
    #   modesetting.enable = true;
    #
    #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    #   powerManagement.enable = true;
    #   # Fine-grained power management. Turns off GPU when not in use.
    #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    #   powerManagement.finegrained = true;
    #
    #   # Use the NVidia open source kernel module (not to be confused with the
    #   # independent third-party "nouveau" open source driver).
    #   # Support is limited to the Turing and later architectures. Full list of 
    #   # supported GPUs is at: 
    #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    #   # Only available from driver 515.43.04+
    #   # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    #   # open = true;
    #
    #   # Enable the Nvidia settings menu,
    #   # accessible via `nvidia-settings`.
    #   nvidiaSettings = true;
    #
    #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #   # package = config.boot.kernelPackages.nvidiaPackages.stable;
    #
    #   prime = {
    #     offload.enable = true;
    #     # sync.enable = true;
    #     intelBusId = "PCI:0:2:0";
    #     nvidiaBusId = "PCI:1:0:0";
    #   };
    # };
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
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        # mesa.drivers
        linux-firmware
      ];
    };
  };

  # PC/SC Smart Card Daemon
  services.pcscd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true; # BUG: when removed cursor disappers in wayland

  # Load nvidia driver for Xorg and Wayland
  # services.xserver.videoDrivers = [ "nvidia" "intel" ];

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
    vulkan-tools
    intel-gpu-tools

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

  system.stateVersion = stateVersion;
}
