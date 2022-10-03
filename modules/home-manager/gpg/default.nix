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
    settings.gpg.enable = mkEnableOpt "gpg";
  };

  config = mkIf config.settings.gpg.enable {
    home.packages = with pkgs; [pinentry-curses];
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    programs.gpg.enable = true;
  };
}
