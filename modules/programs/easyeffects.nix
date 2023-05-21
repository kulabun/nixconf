{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.easyeffects;
in {
  options.programs'.easyeffects.enable = mkEnableOption "easyeffects";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs.easyeffects ];
    };
  };
}
