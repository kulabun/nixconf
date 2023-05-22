{ config, lib, pkgs, ... }:
with lib;
let cfg = config.work'.globalprotect-vpn;
in {
  options.work'.globalprotect-vpn = {
    enable = mkEnableOption "globalprotect vpn";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      globalprotect-openconnect
    ];

    services.globalprotect = {
      enable = true;
      # if you need a Host Integrity Protection report
      csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
    };
  };
}
