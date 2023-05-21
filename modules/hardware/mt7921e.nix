{ config, lib, ... }:
with lib;
let cfg = config.hardware'.mt7921e;
in {
  options.hardware'.mt7921e.enable = mkEnableOption "mt7921e";

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "mt7921e" ];
      extraModprobeConfig = ''
        alias pci:v000014C3d00000608sv*sd*bc*sc*i* mt7921e
      '';
    };

    # MiniForum HX90 has MediaTek 7921k Wi-Fi module. It is supported by mt7921e kernel module, but device is not mapped to this kernel module. So we need to do it.
    # https://askubuntu.com/questions/1376871/rz608-mt7921k-wireless-lan-driver-is-not-supported-on-ubuntu-18-04/1378043#1378043
    services.udev.extraRules = ''
      SUBSYSTEM=="drivers", DEVPATH=="/bus/pci/drivers/mt7921e", ATTR{new_id}="14c3 0608"
    '';
  };
}
