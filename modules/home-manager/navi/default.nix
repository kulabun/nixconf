{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  cheatsPath = "navi/cheats";
in
  with lib;
  with mylib; {
    options = {
      settings.navi.enable = mkEnableOpt "navi";
    };

    config = mkIf config.settings.navi.enable {
      xdg.dataFile."navi/cheats/personal" = {
        source = ./cheats;
        recursive = true;
      };
      programs.navi = {
        enable = true;
        settings = {cheats = {};};
      };
    };
  }
