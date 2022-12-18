{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  font = config.settings.rofi.font;
  terminal = config.settings.sway.terminal;
in
  with lib;
  with mylib; {
    options = {
      settings.rofi = {
        enable = mylib.mkEnableOpt "rofi";
        font = mylib.mkFontOpt "rofi";
      };
    };

    config = mkIf config.settings.rofi.enable {
      xdg.configFile."networkmanager-dmenu/config.ini".text = ''
        [dmenu]
        dmenu_command = ${pkgs.rofi-wayland}/bin/rofi -dmenu
        rofi_highlight = True
        [editor]
        gui_if_available = True
        terminal = ${terminal}
      '';

      home.packages = with pkgs; [
        rofi-wayland-vpn 
        networkmanager_dmenu
      ];

      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        #theme = "${pkgs.dracula-rofi-theme}/theme/config2.rasi";
        theme = "Arc-Dark";
        plugins = with pkgs; [rofi-calc rofi-file-browser rofi-power-menu];
        terminal = "foot";
        font = "${font.name} ${toString font.size}";
        extraConfig = {
          modi = "drun,run,ssh,filebrowser,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
          matching = "fuzzy";
          sort = true;
          sorting-method = "fzf";
          show-icons = true;
          disable-history = false;
        };
      };
    };
  }
