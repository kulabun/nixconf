{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.vivaldi;
in {
  options.programs'.vivaldi.enable = mkEnableOption "Vivaldi";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        (vivaldi.override {
          proprietaryCodecs = true;
          enableWidevine = true;
          commandLineArgs = [
            "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,UseOzonePlatform,WebRTCPipeWireCapturer"
            "--disable-features=UseChromeOSDirectVideoDecoder"
            "--use-gl=egl"
            "--ozone-platform=wayland"
            "--force-dark-mode=enabled"
          ];
        })
      ];
    };
  };
}
