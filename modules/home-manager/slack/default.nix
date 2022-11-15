{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
with lib;
with mylib; {
  options = {
    settings.slack.enable = mkEnableOpt "slack";
  };
  config = mkIf config.settings.slack.enable {
    home.packages = with pkgs'; [ slack ];
  };
}
