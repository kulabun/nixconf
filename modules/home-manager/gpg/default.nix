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
    home.packages = with pkgs; [
      pinentry-curses
      gcr # required for pinentry-gnome3
    ];
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      # pinentryFlavor = "curses";
    };
    programs.gpg.enable = true;
  };
}
