{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.slack;
  my-slack = pkgs.slack.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        rm $out/bin/slack

        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
          --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
      '';
  });
in
{
  options.programs'.slack.enable = mkEnableOption "slack";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs'; [
        my-slack
      ];
    };
  };
}
