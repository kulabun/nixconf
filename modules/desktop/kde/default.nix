{ config, lib, pkgs, pkgs', user, inputs, ... } @ attrs:
let
  cfg = config.desktop'.kde;
  configurationScript = import ./kde-config attrs;
in
with lib; {
  options.desktop'.kde.enable = mkEnableOption "kde";

  config = mkIf cfg.enable {
    shell'.gpg.pinentry = "qt";

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      khelpcenter
      plasma-browser-integration
    ];

    services = {
      dbus.enable = true;

      # disk mounting
      udisks2.enable = true;

      xserver = {
        enable = true;

        displayManager = {
          gdm.enable = false;
          sddm.enable = true;
          defaultSession = "plasmawayland";
        };

        desktopManager = {
          gnome.enable = false;
          plasma5 = {
            enable = true;
          };
        };

        libinput = {
          enable = true;
          touchpad.disableWhileTyping = true;
          touchpad.middleEmulation = true;
          touchpad.naturalScrolling = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [
      wayland
      gtk3
      glib # gsettings
      gcc
      wev # same as xev for xorg but for wayland
      clipman
      ark
      konsole
      libsForQt5.bismuth

      pkgs'.catppuccin-kde
      pkgs'.catppuccin-cursors
      pkgs'.dracula-theme
    ];

    xdg.portal = {
      enable = true;
    };

    programs.dconf.enable = true;

    home-manager = {
      users.${user} = {
        home = {
          # Hack to install configuration without making it immutable
          # Use `nixos-rebuild switch`, it will not be called for `boot`
          activation.kwriteconfig5 = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] configurationScript;
        };
      };
    };
  };
}
