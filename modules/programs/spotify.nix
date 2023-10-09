{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs'.spotify;
in {
  options.programs'.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      spotify
    ];
  };
}
