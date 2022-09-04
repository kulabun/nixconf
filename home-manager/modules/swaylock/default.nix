{ config, pkgs, lib, ... }: {
  home.file = { "Pictures/swaylock.png".source = ../sway/pictures/nix.png; };
  xdg.configFile."swaylock" = {
    source = ./config;
    recursive = true;
  };
}
