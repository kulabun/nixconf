{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.settings;
in {home.packages = with pkgs; [tig];}
