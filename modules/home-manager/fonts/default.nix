{
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.fonts.enable = mkEnableOpt "fonts";
  };
  config = mkIf config.settings.fonts.enable {
    home.packages = with pkgs; [
      font-awesome
      font-vscode-codicons

      (nerdfonts.override {
        fonts = [
          "DroidSansMono"
          "JetBrainsMono"
          "Monofur"
          "SpaceMono"
          "Terminus"
          "SourceCodePro"
          "Hack"
        ];
      })
    ];

    fonts.fontconfig.enable = true;
  };
}
