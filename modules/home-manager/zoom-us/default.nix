{ config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
let
  my-zoom-us = pkgs'.zoom-us.overrideAttrs (old: {
    postFixup =
      old.postFixup
      + ''
        # this helps to overcome default check and zoom is still running on sway
        # but the app still doesn't work, it crashes when I try to share a screen :(
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
      '';
  });
in
with lib;
with mylib; {
  options = {
    settings.zoom-us.enable = mkEnableOpt "zoom-us";
  };
  config = mkIf config.settings.zoom-us.enable {
    home.packages = with pkgs'; [ my-zoom-us ];
  };
}
