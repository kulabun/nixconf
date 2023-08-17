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
