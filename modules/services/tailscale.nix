{ config, lib, pkgs', ... }:
with lib;
let cfg = config.services'.tailscale;
in {
  options.services'.tailscale = {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    environment.systemPackages = with pkgs';[
      tailscale
    ];
  };
}
