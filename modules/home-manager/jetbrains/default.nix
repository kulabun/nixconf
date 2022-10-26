{
  config,
  pkgs,
  pkgs',
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.jetbrains.idea-community.enable = mkEnableOpt "jetbrains-idea-community";
  };

  config = mkIf config.settings.jetbrains.idea-community.enable {
    home.packages = [
      pkgs'.jetbrains.idea-community
    ];
  };
}
