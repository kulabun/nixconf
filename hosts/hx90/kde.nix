{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [
    khelpcenter
    plasma-browser-integration
  ];

  environment.systemPackages = with pkgs; [
    wayland
    gtk3
    glib # gsettings
    gcc
    firefox-wayland
    wev # same as xev for xorg but for wayland
    ulauncher
    clipman
    vlc
    ark
    konsole
    docker-compose 
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
    # wlr.enable = true;
    # # gtk portal needed to make gtk apps happy
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.udisks2.enable = true;
  programs.dconf.enable = true;
  networking.extraHosts = ''
    127.0.0.1 kafka
    127.0.0.1 zookeeper
    127.0.0.1 schema-registry
    127.0.0.1 connect
    127.0.0.1 ksqldb-server
    127.0.0.1 postgres
  '';
}
