{ config, lib, user, ... }:
with lib;
let
  cfg = config.programs'.kitty;
  inherit (cfg) font;
in
{
  options.programs'.kitty = {
    enable = mkEnableOption "kitty";
    font = {
      name = mkOption {
        type = types.str;
        description = "Font name to use in kitty.";
      };
      size = mkOption {
        type = types.int;
        description = "Font size to use in kitty.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      TERMINAL = "kitty";
      GLFW_IM_MODULE = "ibus";
    };

    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
        inherit font;
        theme = "Monokai Pro";
        settings = {
          confirm_os_window_close = 0;
          background = "#2d2a2e";
          selection_background = "#fcfcfa";
          scrollback_lines = 10000;
          enable_audio_bell = false;
          update_check_interval = 0;
          mouse_hide_wait = "3.0";
        };
        keybindings = {
          "ctrl+c" = "copy_or_interrupt";
          "ctrl+shift+c" = "no_op";
          "ctrl+v" = "paste_from_clipboard";
          "ctrl+shift+v" = "no_op";
          "ctrl+shift+s" = "no_op";
          "ctrl+shift+u" = "no_op";
        };
      };
    };
  };
}
