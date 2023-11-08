{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.slack;
in
{
  options.programs'.slack.enable = mkEnableOption "slack";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        slack
      ];
    };
  };
}
