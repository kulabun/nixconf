{ config, pkgs, lib, ... }:
let
  cfg = config.settings;
  font = cfg.programs.waybar.font;
in {
  xdg.configFile = {
    "waybar/config".source = ./config/config;
    "waybar/style.css".source = pkgs.substituteAll {
      src = ./config/style.css;
      fontName = font.name;
      fontSize = font.size;
    };
  };
  programs = { waybar.enable = true; };
}
