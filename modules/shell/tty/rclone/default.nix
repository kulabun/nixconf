{ config
, pkgs
, lib
, ...
}:
with lib; {
  options = {
    settings.rclone.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables rclone";
    };
  };

  config = mkIf config.settings.rclone.enable {
    # xdg.configFile = {
    #   "rclone/rclone.conf".source = ./config/rclone.conf;
    # };
    home.packages = [ pkgs.rclone ];
  };
}
