{ config
, pkgs
, lib
, mylib
, ...
}:
let
  font = config.settings.kitty.font;
  # themes = pkgs.stdenv.mkDerivation {
  #   name = "kitty-themes";
  #   src = builtins.fetchTarball {
  #     url = "https://github.com/dexpota/kitty-themes/archive/fca3335489bdbab4cce150cb440d3559ff5400e2.tar.gz";
  #     sha256 = "11dgrf2kqj79hyxhvs31zl4qbi3dz4y7gfwlqyhi4ii729by86qc";
  #   };
  #   noBuild = true;
  #   installPhase = ''
  #     mkdir -p $out
  #     cp -r ./themes/* $out
  #   '';
  # };
in
with lib; {
  options = {
    settings.kitty = {
      enable = mylib.mkEnableOpt "kitty";
      font = mylib.mkFontOpt "kitty";
    };
  };

  config = mkIf config.settings.kitty.enable {
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
        "ctrl+v" = "paste_from_clipboard";
      };
    };
  };
}
