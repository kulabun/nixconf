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
      settings.taskwarrior.enable = mkEnableOpt "taskwarrior";
    };

    config = mkIf config.settings.taskwarrior.enable {
      programs = {taskwarrior.enable = true;};
    };
  }
