{
  config,
  pkgs,
  pkgs',
  lib,
  mylib,
  ...
}:
let 
  update-scale-settings = pkgs'.writeScriptBin "update-scale-settings" ''
    SCALE=$(swaymsg -t get_outputs | ${pkgs.jq}/bin/jq '.[] | select( .active == true ).scale')

    xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE $SCALE
    export GDK_SCALE=$SCALE
  '';
  idea-community = pkgs'.jetbrains.idea-community.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/idea-community --run "source ${update-scale-settings}/bin/update-scale-settings"
    '';
  });
in
with lib;
with mylib; {
  options = {
    settings.jetbrains.idea-community.enable = mkEnableOpt "jetbrains-idea-community";
  };

  config = mkIf config.settings.jetbrains.idea-community.enable {
    home.packages = [ idea-community ];
  };
}
