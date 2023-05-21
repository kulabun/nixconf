{ pkgs, pkgs', ... }: {
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
    wev # same as xev for xorg but for wayland
    clipman
    ark
    konsole
    libsForQt5.bismuth


    pkgs'.catppuccin-kde
    catppuccin-cursors
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
  };

  services.udisks2.enable = true;
  programs.dconf.enable = true;
}
