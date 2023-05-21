{ config, lib, ... }:
with lib;
let cfg = config.hardware'.power;
in {
  options.hardware'.power = {
    enable = mkEnableOption "power-management support" // { default = true; };
  };

  config = mkIf cfg.enable {
    powerManagement.enable = true;
    powerManagement.powertop.enable = false; # powertop makes my mouse freeze
  };
}
