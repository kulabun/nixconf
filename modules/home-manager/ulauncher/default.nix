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
    settings.ulauncher.enable = mkEnableOpt "ulauncher";
  };
  config = mkIf config.settings.ulauncher.enable {
    home = {
      packages = with pkgs; [
        ulauncher
      ];
    };
  };
}
