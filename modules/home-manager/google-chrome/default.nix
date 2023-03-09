{ config
, pkgs
, lib
, mylib
, ...
}:
with lib;
with mylib; {
  options = {
    settings.google-chrome.enable = mkEnableOpt "google-chrome";
  };

  config = mkIf config.settings.google-chrome.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
