{
  config,
  pkgs,
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
    home.packages = with pkgs; [
      jetbrains.idea-community
    ];
  };
}
