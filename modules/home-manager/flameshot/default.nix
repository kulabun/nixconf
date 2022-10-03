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
    settings.flameshot.enable = mkEnableOpt "flameshot";
  };
  config = mkIf config.settings.flameshot.enable {
    services.flameshot = {enable = true;};
  };
}
