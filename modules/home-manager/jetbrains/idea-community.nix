{
  config,
  pkgs,
  pkgs',
  lib,
  mylib,
  ...
}:
let 
  idea-community = pkgs'.jetbrains.idea-community.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/idea-community --unset GDK_SCALE
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
