{ config, pkgs, lib, ... }: {
  xdg.configFile."mako" = {
    source = ./config;
    recursive = true;
  };
}
