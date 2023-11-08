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
      efi.efiSysMountPoint = "/boot/efi";
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      luks.devices."luks-950903eb-8bbc-4c93-bfcf-7ff8b8462579".device = "/dev/disk/by-uuid/950903eb-8bbc-4c93-bfcf-7ff8b8462579";

      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };


      # Enable swap on luks
      luks.devices."luks-0beaaea9-239c-4ee9-b90b-b51687accdbb".device = "/dev/disk/by-uuid/0beaaea9-239c-4ee9-b90b-b51687accdbb";
      luks.devices."luks-0beaaea9-239c-4ee9-b90b-b51687accdbb".keyFile = "/crypto_keyfile.bin";
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1c4c6aa6-af0c-41a6-a0ee-cefdfacd8fda";
      fsType = "ext4";
    };

    "/boot/efi" = {
      device = "/dev/disk/by-uuid/2055-A41F";
      fsType = "vfat";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/38e302d6-edfc-45e0-b6f6-e6e06c4366b6"; }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  networking.hostName = "dell7573";

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
    gcloud.enable = true;
    dev-tools.enable = true;
    scripts.enable = true;
    lorri.enable = true;
    gopass.enable = true;
    youtube-dl.enable = true;
    other.enable = true;
  };

  programs' = {
    brave.enable = false;
    chrome.enable = true;
    firefox.enable = false;
    vivaldi.enable = false;
    easyeffects.enable = true;
    obs-studio.enable = true;
    vscode.enable = false;
    yubikey.enable = true;
    slack.enable = true;
    libreoffice.enable = true;
    bitwarden.enable = true;
    zoom-us.enable = true;
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

  work' = {
    lxc.enable = true;
    sops.enable = true;
    mongodb-compass.enable = true;
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

  # PC/SC Smart Card Daemon
  services.pcscd.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true; # BUG: when removed cursor disappers in wayland

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

  system.stateVersion = stateVersion;
}
