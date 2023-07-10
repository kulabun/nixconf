{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs'.vlc;
in {
  options.programs'.vlc.enable = mkEnableOption "vlc" // { default = true; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      vlc
    ];
  };
}
