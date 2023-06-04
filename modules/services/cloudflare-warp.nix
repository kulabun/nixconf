{ config, lib, pkgs', ... }:
with lib;
let cfg = config.services'.cloudflare-warp;
in {
  options.services'.cloudflare-warp = {
    enable = mkEnableOption "cloudflare-warp";
  };

  config = mkIf cfg.enable {
    systemd.packages = with pkgs';[
      cloudflare-warp
    ];

    systemd.services."warp-svc".wantedBy = [ "multi-user.target" ];
    systemd.user.services."warp-taskbar".wantedBy = [ "tray.target" ];

    environment.systemPackages = with pkgs';[
      desktop-file-utils # required to register callback through teams-enroll
      cloudflare-warp
    ];
  };
}
