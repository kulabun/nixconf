{ config, lib, pkgs, pkgs', user, ... }:
with lib;
let
  cfg = config.programs'.zoom-us;
  # BUG: Zoom screen-sharing shows a black screen with a mouse when NVIDIA driver is enabled together with Intel
  # BUG: Zoom screen-sharing doesn't work on nixos-unstable. The screen is completely black(even no cursor compared to NVIDIA problem).
  # The last version that is known to work properly is 5.14.7(2928)
  my-zoom-us = pkgs.zoom-us.overrideAttrs (old: {
    postFixup =
      old.postFixup
      + ''
        # Zoom screen-sharing got broken with an update in June 2023. On screensharing people see a black screen.

        # this helps to overcome default check and zoom is still running on sway
        # but the app still doesn't work, it crashes when I try to share a screen :(

        # No scale
        # wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --set XDG_CURRENT_DESKTOP gnome --set QT_QPA_PLATFORM xcb
        # wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set XDG_CURRENT_DESKTOP gnome --set QT_QPA_PLATFORM xcb
        # wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
        # wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE

        # wrapProgram $out/bin/zoom-us --set XDG_CURRENT_DESKTOP GNOME
        # wrapProgram $out/bin/zoom --set XDG_CURRENT_DESKTOP GNOME

        # Scale x2
        # wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --set QT_DEVICE_PIXEL_RATIO 2
        # wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_DEVICE_PIXEL_RATIO 2
        
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --set QT_SCALE_FACTOR 1.5
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --set QT_SCALE_FACTOR 1.5
      '';
  });
in
with lib; {
  options.programs'.zoom-us.enable = mkEnableOption "zoom-us";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [
        my-zoom-us
        # pkgs.zoom-us
      ];
    };
  };
}
