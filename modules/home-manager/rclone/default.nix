{ config, pkgs, lib, ... }:
{
  # xdg.configFile = {
  #   "rclone/rclone.conf".source = ./config/rclone.conf;
  # };
  home.packages = [ pkgs.rclone ];
}
