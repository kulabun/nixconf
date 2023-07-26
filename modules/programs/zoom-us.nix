{ config, lib, pkgs, user, ... }:
with lib;
let
  cfg = config.programs'.zoom-us;
  my-zoom-us = pkgs.zoom-us.overrideAttrs (old: {
    postFixup =
      old.postFixup
      + ''
        # this helps to overcome default check and zoom is still running on sway
        # but the app still doesn't work, it crashes when I try to share a screen :(
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --set QT_DEVICE_PIXEL_RATIO 2
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_DEVICE_PIXEL_RATIO 2
      '';
  });
in
with lib; {
  options.programs'.zoom-us.enable = mkEnableOption "zoom-us";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [
        my-zoom-us
      ];
    };
  };
}
