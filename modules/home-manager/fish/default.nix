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
    settings.fish.enable = mkEnableOpt "fish";
  };
  config = mkIf config.settings.fish.enable {
    programs.fish = {enable = true;};
  };
}
