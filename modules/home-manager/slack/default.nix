{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
let
  my-slack = pkgs'.slack.overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        rm $out/bin/slack

        makeWrapper $out/lib/slack/slack $out/bin/slack \
          --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
          --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
          --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
      '';
  });
in
with lib;
with mylib; {
  options = {
    settings.slack.enable = mkEnableOpt "slack";
  };
  config = mkIf config.settings.slack.enable {
    home.packages = with pkgs'; [
      my-slack
      # xdg-desktop-portal-wlr
      # xdg-desktop-portal-gtk
    ];
  };
}
