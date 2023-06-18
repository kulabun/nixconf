{ config, lib, ... }:
with lib;
let cfg = config.system'.systemd-boot;
in {
  options.system'.systemd-boot.enable = mkEnableOption "systemd-boot" // { default = true; };

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

      tmp.useTmpfs = true;
    };
  };
}
