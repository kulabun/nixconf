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

            # "--disable-features=UseChromeOSDirectVideoDecoder"
            # "--disable-gpu-memory-buffer-compositor-resources"
            # "--disable-gpu-memory-buffer-video-frames"
            # "--enable-hardware-overlays"
            # "--enable-accelerated-video-decode"
            # "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,RawDraw,WebRTCPipeWireCapturer,UseOzonePlatform"
            # "--ozone-platform=wayland"
            # "--ignore-gpu-blocklist"
            # "--enable-gpu-rasterization"
            # "--enable-zero-copy"
            # "--disable-gpu-driver-bug-workarounds"
            # "--enable-native-gpu-memory-buffers"
            # "--use-cmd-decoder=passthrough"
            # "--ozone-platform-hint=auto"
            # "--use-vulkan"
            # "--force-dark-mode=enabled"
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
