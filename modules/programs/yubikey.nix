{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs'.yubikey;
in {
  options.programs'.yubikey.enable = mkEnableOption "YubiKey";

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
      yubikey-personalization-gui
    ];

    services.pcscd.enable = true;
  };
}
