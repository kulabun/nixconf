{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.chrome;
in {
  options.programs'.chrome.enable = mkEnableOption "Chrome";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.chromium = {
        enable = true;
        package = pkgs.google-chrome.override {
          commandLineArgs = [
            "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,UseOzonePlatform,WebRTCPipeWireCapturer"
            "--disable-features=UseChromeOSDirectVideoDecoder"
            "--use-gl=egl"
            "--ozone-platform=wayland"
            "--force-dark-mode=enabled"
          ];
        };
      };
      programs.zsh = {
        shellAliases = {
          "chrome" = "google-chrome-stable";
        };
      };
    };
  };
}
