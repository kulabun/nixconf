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
    settings.jetbrains.idea-ultimate.enable = mkEnableOpt "jetbrains-idea-ultimate";
  };

  config = mkIf config.settings.jetbrains.idea-ultimate.enable {
    home.packages = with pkgs'; [ 
      jetbrains.idea-ultimate
    ];
  };
}
