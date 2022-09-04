{ config, pkgs, lib, ... }: {
  programs.foot = {
    enable = true;
    # TODO: check why foot started as a service dont have PATH defined. For now it starts from Sway config
    server.enable = true;
    settings = {
      main = {
        dpi-aware = "yes";
        term = "xterm-color";
        font = "SauceCodePro Nerd Font:size=10";
        notify = "notify-send -a Foot -i foot \${title} \${body}";
      };
      colors = {
        # Normal/regular colors (color palette 0-7
        regular0 = "21222c";
        regular1 = "ff5555";
        regular2 = "50fa7b";
        regular3 = "f1fa8c";
        regular4 = "bd93f9";
        regular5 = "ff79c6";
        regular6 = "8be9fd";
        regular7 = "f8f8f2";

        # Bright colors (color palette 8-15)
        bright0 = "21222c";
        bright1 = "ff6e6e";
        bright2 = "69ff94";
        bright3 = "ffffa5";
        bright4 = "d6acff";
        bright5 = "ff92df";
        bright6 = "a4ffff";
        bright7 = "ffffff";

        # Misc colors
        selection-foreground = "ffffff";
        selection-background = "44475a";
        urls = "8be9fd";
      };
      key-bindings = {
        clipboard-copy = "Control+c";
        clipboard-paste = "Control+v";
      };
    };
  };
}
