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
    settings.lorri.enable = mkEnableOpt "lorri";
  };

  config = mkIf config.settings.lorri.enable {
    home = {packages = with pkgs; [direnv];};
    services = {lorri.enable = true;};
  };
}
