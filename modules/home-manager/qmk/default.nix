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
    settings.qmk.enable = mkEnableOpt "qmk";
  };

  config = mkIf config.settings.qmk.enable {
    xdg.configFile = {
      "qmk" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
