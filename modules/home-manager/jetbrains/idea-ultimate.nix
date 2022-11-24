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
  '';
  idea-ultimate = pkgs'.jetbrains.idea-ultimate.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/idea-ultimate --unset GDK_SCALE --run "${update-scale-settings}/bin/update-scale-settings"
    '';
  });
in
with lib;
with mylib; {
  options = {
    settings.jetbrains.idea-ultimate.enable = mkEnableOpt "jetbrains-idea-ultimate";
  };

  config = mkIf config.settings.jetbrains.idea-ultimate.enable {
    home.packages = [ idea-ultimate ];
  };
}
