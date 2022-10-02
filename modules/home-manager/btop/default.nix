{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.settings;
in {
  # programs.btop = {enable = true;};
  home.packages = with pkgs; [btop];
}
