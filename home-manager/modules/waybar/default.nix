{ config, pkgs, lib, ... }: {
  xdg.configFile."waybar" = {
    source = ./config;
    recursive = true;
  };
  programs = { waybar.enable = true; };
}
