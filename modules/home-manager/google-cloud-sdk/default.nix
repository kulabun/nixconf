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
    settings.google-cloud-sdk.enable = mkEnableOpt "google-cloud-sdk";
  };

  config = mkIf config.settings.google-chrome.enable {
    home.packages = with pkgs; [google-cloud-sdk];
  };
}
