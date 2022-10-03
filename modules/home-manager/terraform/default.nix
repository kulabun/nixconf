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
      settings.terraform.enable = mkEnableOpt "terraform";
    };

    config = mkIf config.settings.terraform.enable {
      home.packages = with pkgs; [terraform];
    };
  }
