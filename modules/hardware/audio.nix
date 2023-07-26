{ config, lib, user, ... }:
with lib;
let
  cfg = config.hardware'.audio;
in
{
  options.hardware'.audio = {
    enable = mkEnableOption "multimedia support" // { default = true; };
  };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "audio" "video" "camera" ];

    sound = {
      enable = true;
      mediaKeys.enable = true;
    };

    hardware.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;

    # screensharing
    xdg.portal.enable = true;
  };
}
