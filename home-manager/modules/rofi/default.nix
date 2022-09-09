{ config, pkgs, lib, ... }: {
  home.packages = let
  in with pkgs; [
    todofi-sh
    rofi-wayland-vpn
  ];
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    #theme = "${pkgs.dracula-rofi-theme}/theme/config2.rasi";
    theme = "Arc-Dark";
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
      rofi-file-browser
      rofi-power-menu
    ];
    terminal = "foot";
    font = "JetBrainsMono Nerd Font 10";
    #font = " SauceCodePro Nerd Font Mono 10";
    extraConfig = {
      modi =
        "drun,run,emoji,ssh,filebrowser,power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
      matching = "fuzzy";
      show-icons = true;
      disable-history = false;
    };
  };
}
