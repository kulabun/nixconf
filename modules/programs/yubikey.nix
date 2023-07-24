{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs'.yubikey;
in {
  options.programs'.yubikey.enable = mkEnableOption "YubiKey" // { default = true; };

  config = mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-personalization-gui
      yubikey-manager
      yubikey-manager-qt
    ];

    # PC/SC Smart Card Daemon
    services.pcscd.enable = true;
  };
}
