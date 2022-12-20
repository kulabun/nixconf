{ config
, pkgs
, lib
, ...
}:
let
  # bash script to let dbus know about important env variables and
  # propogate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      sway = super.sway.override {
        sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: {
          postInstall = ''
            sed -i "s#Exec=.*#Exec=${pkgs.systemd}/bin/systemd-cat -t sway ${super.sway}/bin/sway#g" $out/share/wayland-sessions/sway.desktop
          '';
        });
      };
    })
  ];

  #services.xserver.displayManager.sessionPackages = [ sway-systemd ];
  #services.xserver.displayManager.defaultSession = "sway-systemd";
  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    libappindicator-gtk3
    networkmanagerapplet
    gcc
    swaylock
    swayidle
    gtk3
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    #bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    firefox-wayland
    wev # same as xev for xorg but for wayland
    ulauncher
    clipman
    polkit
    polkit_gnome
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
    extraSessionCommands = ''
      # TODO: Why doesn't it work?

      # Disable HiDPI scaling for X apps
      # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
      export GDK_SCALE=2

      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export MOZ_ENABLE_WAYLAND=1

      # Tell toolkits to use wayland
      export CLUTTER_BACKEND=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_QPA_PLATFORMTHEME=qt5ct
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export ECORE_EVAS_ENGINE=wayland-egl
      export ELM_ENGINE=wayland_egl
      export SDL_VIDEODRIVER=wayland

      # Fix Java
      export _JAVA_AWT_WM_NONREPARENTING=1

      export NO_AT_BRIDGE=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export GTK_IM_MODULE=ibus
      export QT_IM_MODULE=ibus
      export XMODIFIERS=@im=ibus
      export IBUS_DISCARD_PASSWORD_APPS='firefox,.*chrome.*'
    '';
  };

  security.polkit = {
    enable = true;
  
    # Fix auto suspend
    # https://github.com/NixOS/nixpkgs/issues/100390
    extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
              action.id == "org.freedesktop.login1.hibernate" ||
              action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
          {
              return polkit.Result.NO;
          }
      });
    '';
  };

  services.udisks2.enable = true;
  services.blueman.enable = true;

  # services.xserver.displayManager.gdm.autoSuspend = false;

  # security.sudo.extraConfig = ''
  #   %wheel      ALL=(ALL:ALL) NOPASSWD: ${pkgs.kbd}/bin/chvt
  # '';
}
