{ config, lib, pkgs, ... }:
with lib;
let cfg = config.hardware'.rtl8821au;
in {
  options.hardware'.rtl8821au.enable = mkEnableOption "rtl8821au";

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "8821au" ];
      extraModulePackages = with pkgs.linuxPackages; [ rtl8821au ];
    };
  };
}
