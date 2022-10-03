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
    settings.gtk.enable = mkEnableOpt "gtk";
  };

  config = mkIf config.settings.gtk.enable {
    gtk = {
      enable = true;
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "DejaVu Sans";
        #name = "Roboto";
      };
    };
  };
}
