{ config, lib, ... }:
with lib;
let cfg = config.hardware'.systemd-boot;
in {
  options.hardware'.systemd-boot.enable = mkEnableOption "systemd-boot" // { default = true; };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = 5;

        systemd-boot = {
          enable = true;
        };

        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot/efi";
        };
      };

      tmpOnTmpfs = true;
    };
  };
}
