{ config, lib, pkgs', ... }:
with lib;
let
  cfg = config.services'.cloudflare-warp;
  cloudflare-warp = (pkgs'.cloudflare-warp.overrideAttrs (old: {
    src = pkgs'.fetchurl {
      url = "https://pkg.cloudflareclient.com/pool/jammy/main/c/cloudflare-warp/cloudflare-warp_2023.7.40-1_amd64.deb";
      sha256 = "sha256-hhvMqebwsf/S90i7kjSJAttSXnENyd/QGyBaLvEXeCM=";
    };
    unpackPhase = null;
  }));

  # cloudflare-warp = (pkgs'.cloudflare-warp.overrideAttrs (old: {
  #   src = pkgs'.fetchurl {
  #     url = "https://pkg.cloudflareclient.com/pool/jammy/main/c/cloudflare-warp/cloudflare-warp_2023.9.301-1_amd64.deb";
  #     sha256 = "sha256-mkkBpYLfByqWzjQjcvT5F8n1bEMQVqG1D+DuvfOfd9k=";
  #   };
  #   unpackPhase = null;
  #   buildInputs = with pkgs'; [
  #     dbus
  #     stdenv.cc.cc.lib
  #     dbus.lib
  #     glibc
  #     gtk3
  #     pango
  #     gobject-introspection
  #     cairo
  #     gdk-pixbuf
  #     wayland
  #     expat
  #     fontconfig
  #
  #     nss
  #     nspr
  #     pango
  #     udev
  #     libdrm
  #     libuuid
  #   ];
  # }));
in
{
  options.services'.cloudflare-warp = {
    enable = mkEnableOption "cloudflare-warp";
  };

  config = mkIf cfg.enable {
    systemd.packages = [
      cloudflare-warp
    ];

    systemd.services."warp-svc".wantedBy = [ "multi-user.target" ];
    systemd.user.services."warp-taskbar".wantedBy = [ "tray.target" ];

    environment.systemPackages = [
      pkgs'.desktop-file-utils # required to register callback through teams-enroll
      cloudflare-warp
    ];
  };
}
