{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.programs'.libreoffice;
in {
  options.programs'.libreoffice.enable = mkEnableOption "libreoffice";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libreoffice-qt
    ];
  };
}
