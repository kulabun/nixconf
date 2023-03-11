{
  config,
  pkgs,
  pkgs',
  lib,
  mylib,
  ...
}:
let 
  idea-ultimate = pkgs'.jetbrains.idea-ultimate.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      wrapProgram $out/bin/idea-ultimate --unset GDK_SCALE
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
