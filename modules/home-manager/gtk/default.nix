{
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
let 
  font = config.settings.gtk.font;
  cursor = config.settings.cursor;
in 
with lib;
with mylib; {
  options = {
    settings.gtk = {
      enable = mkEnableOpt "gtk";
      font = mylib.mkFontOpt "gtk";
    };
  };

  config = mkIf config.settings.gtk.enable {
    home.packages = [ pkgs.capitaine-cursors ];
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
      cursorTheme = {
        package = pkgs.capitaine-cursors;
        name = cursor.theme;
        size = cursor.size;
      };
      font = {
        name = font.name;
        size = font.size;
      };
    };
  };
}
