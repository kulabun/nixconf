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
            # background = "2C2525"; -- nice brownish color
            background = "2d2a2e";
            foreground = "FFFFFF";

            selection-foreground = "FFF8F9";
            selection-background = "FFF8F9";

            regular0 = "19181A"; # black
            regular1 = "FD6883"; # red
            regular2 = "ADDA78"; # green
            regular3 = "F9CC6C"; # yellow
            regular4 = "85DACC"; # blue
            regular5 = "FD6883"; # magenta
            regular6 = "51B6C2"; # cyan
            regular7 = "FFFFFF"; # white

            bright0 = "C3C8D2";
            bright1 = "CC241D";
            bright2 = "40883F";
            bright3 = "FFE585";
            bright4 = "0287C8";
            bright5 = "E1ACFF";
            bright6 = "68D1DE";
            bright7 = "FFFFFF";

            # background = "2d2a2e";
            # foreground = "fcfcfa";
            #
            # regular0 = "403e41";   # black
            # regular1 = "ff6188";   # red
            # regular2 = "a9dc76";   # green
            # regular3 = "ffd866";   # yellow
            # regular4 = "fc9867";   # blue
            # regular5 = "ab9df2";   # magenta
            # regular6 = "78dce8";   # cyan
            # regular7 = "fcfcfa";   # white
            #
            # bright0 = "727072";    # bright black
            # bright1 = "ff6188";    # bright red
            # bright2 = "a9dc76";    # bright green
            # bright3 = "ffd866";    # bright yellow
            # bright4 = "fc9867";    # bright blue
            # bright5 = "ab9df2";    # bright magenta
            # bright6 = "78dce8";    # bright cyan
            # bright7 = "fcfcfa";    # bright white
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
