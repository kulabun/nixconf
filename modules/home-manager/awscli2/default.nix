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
    settings.awscli2.enable = mkEnableOpt "awscli2";
  };

  config = mkIf config.settings.awscli2.enable {
    home.packages = with pkgs; [awscli2];
  };
}
