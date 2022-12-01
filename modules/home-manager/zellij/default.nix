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
    settings.zellij.enable = mkEnableOpt "zellij";
  };
  config = mkIf config.settings.zellij.enable {
    home.packages = [pkgs'.zellij];
    xdg.configFile."zellij/config.kdl".source = ./config/config.kdl;

    # programs.zellij = {
    #   enable = true;
    #   package = pkgs'.zellij;
    #   settings = {
    #     default_mode = "locked";
    #     pane_frames = false;
    #     scroll_buffer_size = 50000;
    #     theme = "catpuccin-mocha";
    #     themes.catpuccin-mocha = {
    #       bg = "#585b70";
    #       fg = "#cdd6f4";
    #       red = "#f38ba8";
    #       green = "#a6e3a1";
    #       blue = "#89b4fa";
    #       yellow = "#f9e2af";
    #       magenta = "#f5c2e7";
    #       orange = "#fab387";
    #       cyan = "#89dceb";
    #       black = "#181825";
    #       white = "#cdd6f4";
    #     };
    #   };
    # };
  };
}
