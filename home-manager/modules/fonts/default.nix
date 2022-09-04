{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    font-awesome
    (nerdfonts.override {
      fonts = [
        "DroidSansMono"
        "JetBrainsMono"
        "Monofur"
        "SpaceMono"
        "Terminus"
        "SourceCodePro"
      ];
    })
  ];

  fonts.fontconfig.enable = true;
}
