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
    settings.btop.enable = mkEnableOpt "btop";
  };

  config = mkIf config.settings.btop.enable {
    # programs.btop = {enable = true;};
    home.packages = with pkgs; [btop];
  };
}
