{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  font = config.settings.waybar.font;
in
  with lib;
  with mylib; {
    options = {
      settings.waybar = {
        enable = mylib.mkEnableOpt "waybar";
        font = mylib.mkFontOpt "waybar";
      };
    };

    config = mkIf config.settings.waybar.enable {
      xdg.configFile = {
        "waybar/config".source = ./config/config;
        "waybar/style.css".source = pkgs.substituteAll {
          src = ./config/style.css;
          fontName = font.name;
          fontSize = font.size;
        };
      };
      programs = {waybar.enable = true;};
    };
  }
