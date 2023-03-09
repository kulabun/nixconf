# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ../../modules/nixos/default
    ../../modules/nixos/kde

    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    kernelModules = ["mt7921e"];

    # Setup keyfile
    initrd = {secrets = {"/crypto_keyfile.bin" = null;};};
  };

  # MiniForum HX90 has MediaTek 7921k Wi-Fi module. It is supported by mt7921e kernel module, but device is not mapped to this kernel module. So we need to do it.
  # https://askubuntu.com/questions/1376871/rz608-mt7921k-wireless-lan-driver-is-not-supported-on-ubuntu-18-04/1378043#1378043
  services.udev.extraRules = ''
    SUBSYSTEM=="drivers", DEVPATH=="/bus/pci/drivers/mt7921e", ATTR{new_id}="14c3 0608"
  '';
  boot.extraModprobeConfig = ''
    alias pci:v000014C3d00000608sv*sd*bc*sc*i* mt7921e
  '';

  hardware.bluetooth.enable = true;
  networking.hostName = "konstantin-desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.extraHosts = ''
  #   127.0.0.1 localhost
  # '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Required for chromecast https://github.com/NixOS/nixpkgs/issues/49630
  services.avahi.enable = true;

  # PC/SC Smart Card Daemon
  services.pcscd.enable = true;

  # Set your time zone.
  time.timeZone = "US/Pacific";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true; # BUG: when removed cursor disappers in wayland
  #programs.sway.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false; # use sdde + KDE
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.sshd.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.konstantin = {
    isNormalUser = true;
    description = "Konstantin";
    extraGroups = ["networkmanager" "wheel" "docker" "video"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      usbutils # lsusb
      pciutils # lspci
      procps # pgrep, pkill
      pavucontrol # volume control
      pulseaudio
      libnotify # notify-send
      mpd
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  ];

  # Auto-completion wouldn't work if Zsh is enabled only in home-manager.
  # See https://github.com/nix-community/home-manager/issues/2562
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
