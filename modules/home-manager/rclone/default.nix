{
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.rclone.enable = mkEnableOpt "rclone";
  };

  config = mkIf config.settings.rclone.enable {
    # xdg.configFile = {
    #   "rclone/rclone.conf".source = ./config/rclone.conf;
    # };
    home.packages = [pkgs.rclone];
  };
}
