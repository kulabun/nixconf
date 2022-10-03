{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  font = config.settings.mako.font;
  dummy-package = pkgs.runCommandLocal "dummy-package" {} "mkdir $out";
in
  with lib;
  with mylib; {
    options = {
      settings.mako = {
        enable = mylib.mkEnableOpt "mako";
        font = mylib.mkFontOpt "mako";
      };
    };

    config = mkIf config.settings.mako.enable {
      # xdg.configFile."mako/config".source = pkgs.substituteAll {
      #   src = ./config/config;
      #   fontName = font.name;
      #   fontSize = font.size;
      # };
      programs.mako = {
        enable = true;
        package = dummy-package // {outPath = "@mako@";};
        sort = "-time";
        maxVisible = 10;
        layer = "overlay";
        anchor = "top-right";
        font = "${font.name} ${toString font.size}";

        backgroundColor = "#282a36";
        textColor = "#cccccc";
        width = 300;
        height = 100;
        margin = "20";
        padding = "20";
        progressColor = "over #5588AAFF";
        icons = false;
        maxIconSize = 64;

        markup = true;
        actions = true;
        format = "<b>%s</b>\\n%b";
        defaultTimeout = 10000;
        ignoreTimeout = false;

        borderRadius = 5;
        borderSize = 1;
        borderColor = "#f1fa8c";

        extraConfig = ''
          [urgency=low]
          border-color=#f1fa8c

          [urgency=normal]
          border-color=#f1fa8c

          [urgency=high]
          border-color=#ff5555
        '';
      };
    };
  }
