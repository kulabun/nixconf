{ pkgs, ... }: {
  imports = [ ../../modules/default ];

  home = {
    enableNixpkgsReleaseCheck = true;

    sessionPath = [ "$HOME/.local/bin" "$HOME/bin" ];

    sessionVariables = {
      PAGER = "less -R";
      TIME_STYLE = "long-iso"; # for core-utils
      DEFAULT_BROWSER = "firefox";
      MOZ_ENABLE_WAYLAND = 1;
      MOZ_WEBRENDER = 1;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      XDG_SESSION_TYPE = "wayland";
      GSETTINGS_SCHEMA_DIR = "${pkgs.glib.getSchemaPath pkgs.gtk3}";
    };

    packages = with pkgs; [
      nix-index # search package by file
      nixos-option

      atool
      gopass

      watson
      wev # same as xev for xorg but for wayland
      # Intalled system-wide
      #libappindicator-gtk3
      #glib # gsettings
      #wl-clipboard
      #gcc
      #gnome3.adwaita-icon-theme
      #dracula-theme # gtk-theme
      #sway
      #swaylock
      #swayidle
      #wayland
      #gtk3
      #networkmanager
      #networkmanagerapplet
      #slurp
      #grim

      usbutils # lsusb
      pciutils # lspci
      libnotify # notify-send
      procps # pgrep, pkill
      pavucontrol # volume control
      pulseaudio
      mpd
      #gdk-pixbuf
      #librsvg # support tray icons in svg
      fd
      ripgrep
      #awscli
      #nodejs
      scmpuff
      #syncthing
      #tmux
      #tmuxp
      #zellij
      #light
      #bitwarden
      unzip
      unrar
      feh
      ranger
      terraform
      firefox-wayland
      ulauncher
      gnome.zenity
      clipman
    ];

    file = {
      #".config/ulauncher".source = ~/dotfiles/config/ulauncher;
      ".sdks/jdk8".source = pkgs.openjdk8;
      ".sdks/jdk11".source = pkgs.openjdk11;
      ".sdks/jdk17".source = pkgs.openjdk17;
      ".sdks/python38".source = pkgs.python38;
      ".sdks/python3".source = pkgs.python3;
      ".sdks/nodejs-16_x".source = pkgs.nodejs-16_x;
    };
  };

  services = {
    #blueman-applet.enable = true; # doesnt work on wayland
    playerctld.enable = true;
  };
}

