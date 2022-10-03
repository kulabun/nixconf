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
    settings.go-chromecast.enable = mkEnableOpt "go-chromecast";
  };

  config = mkIf config.settings.go-chromecast.enable {
    home.packages = with pkgs; [go-chromecast];
  };
}
