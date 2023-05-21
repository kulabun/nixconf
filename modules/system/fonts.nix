{ config, lib, user, pkgs, ... }:
with lib;
let cfg = config.programs'.fonts;
in {
  options.programs'.fonts.enable = mkEnableOption "fonts" // { default = true; };

  config = mkIf cfg.enable {

    fonts = {
      fonts = with pkgs; [
        font-awesome
        dejavu_fonts
        inter
        open-dyslexic
        open-sans
        roboto
        roboto-mono
        source-sans-pro
        source-serif-pro

        (nerdfonts.override {
          fonts = [
            "DroidSansMono"
            "JetBrainsMono"
            "SpaceMono"
            "Terminus"
            "SourceCodePro"
            "Hack"
          ];
        })
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ "SauceCodePro Nerd Font" ];
          sansSerif = [ "Inter" ];
          serif = [ "Noto Serif" ];
        };
      };
    };

    home-manager.users.${user} = {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [ ];
    };
  };
}
