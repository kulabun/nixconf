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
    settings.xdg.enable = mkEnableOpt "xdg";
  };

  config = mkIf config.settings.xdg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = ["firefox.desktop"];
          "x-scheme-handler/https" = ["firefox.desktop"];
          "x-scheme-handler/about" = ["firefox.desktop"];
          "x-scheme-handler/unknown" = ["firefox.desktop"];
          "text/html" = ["firefox.desktop"];
          "application/x-extension-htm" = ["firefox.desktop"];
          "application/x-extension-html" = ["firefox.desktop"];
          "application/x-extension-shtml" = ["firefox.desktop"];
          "application/xhtml+xml" = ["firefox.desktop"];
          "application/x-extension-xhtml" = ["firefox.desktop"];
          "application/x-extension-xht" = ["firefox.desktop"];
        };
      };
      dataFile."applications" = {
        source = ./data/applications;
        recursive = true;
      };
    };
  };
}
