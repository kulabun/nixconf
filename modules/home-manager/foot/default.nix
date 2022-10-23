{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  font = config.settings.foot.font;
in
  with lib; {
    options = {
      settings.foot = {
        enable = mylib.mkEnableOpt "foot";
        font = mylib.mkFontOpt "foot";
      };
    };

    # options.settings.foot.enable = lib.mkOption {
    #   type = lib.types.bool;
    #   default = false;
    # };

    config = mkIf config.settings.foot.enable {
      programs.foot = {
        enable = true;
        # TODO: check why foot started as a service dont have PATH defined. For now it starts from Sway config
        server.enable = true;
        settings = {
          main = {
            # dpi-aware = "yes";
            dpi-aware = "no";
            # term = "xterm-color";
            font = "${font.name}:size=${toString font.size}";
            notify = "notify-send -a Foot -i foot \${title} \${body}";
          };
          colors = {
            background = "2D2A2E";
            foreground = "FCFCFA";
            regular0 = "403E41";
            regular1 = "FF6188";
            regular2 = "A9DC76";
            regular3 = "FFD866";
            regular4 = "FC9867";
            regular5 = "AB9DF2";
            regular6 = "78DCE8";
            regular7 = "FCFCFA";
            bright0 = "727072";
            bright1 = "FF6188";
            bright2 = "A9DC76";
            bright3 = "FFD866";
            bright4 = "FC9867";
            bright5 = "AB9DF2";
            bright6 = "78DCE8";
            bright7 = "FCFCFA";
          };
          key-bindings = {
            clipboard-copy = "Control+c";
            clipboard-paste = "Control+v";
            search-start = "Control+Shift+f";
          };
          search-bindings = {
            find-next = "Control+n";
            find-prev = "Control+p";
          };
        };
      };
    };
  }
