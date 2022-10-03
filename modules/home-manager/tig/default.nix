{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  cfg = config.settings;
in
  with lib;
  with mylib; {
    options = {
      settings.tig.enable = mkEnableOpt "tig";
    };

    config = mkIf config.settings.tig.enable {
      home.packages = with pkgs; [tig];
    };
  }
