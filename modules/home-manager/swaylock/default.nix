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
    settings.swaylock.enable = mkEnableOpt "swaylock";
  };

  config = mkIf config.settings.swaylock.enable {
    home.file = {"Pictures/swaylock.png".source = ../sway/pictures/nix.png;};
    xdg.configFile."swaylock" = {
      source = ./config;
      recursive = true;
    };
  };
}
