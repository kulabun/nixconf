{ config, lib, ... }:
with lib;
let cfg = config.programs'.firefox;
in {
  options.programs'.firefox.enable = mkEnableOption "Firefox";

  config = mkIf cfg.enable {
    # Enable wayland support for firefox
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
    };

    programs.firefox = {
      enable = true;
      preferences = {
        "extensions.pocket.enabled" = false;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
