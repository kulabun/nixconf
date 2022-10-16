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
    settings.firefox.enable = mkEnableOpt "firefox";
  };
  config = mkIf config.settings.firefox.enable {
    programs.firefox = {
      enable = true;
      };
  };
}
