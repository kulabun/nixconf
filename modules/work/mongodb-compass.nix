{ config, lib, pkgs, ... }:
with lib;
let cfg = config.work'.mongodb-compass;
in {
  options.work'.mongodb-compass = {
    enable = mkEnableOption "mongodb compass";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mongodb-compass
    ];
  };
}
