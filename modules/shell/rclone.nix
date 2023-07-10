{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.rclone;
in
{
  options.shell'.rclone.enable = mkEnableOption "rclone";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
    # xdg.configFile = {
    #   "rclone/rclone.conf".source = ./config/rclone.conf;
    # };
      home.packages = with pkgs; [ rclone ];
    };
  };
}

