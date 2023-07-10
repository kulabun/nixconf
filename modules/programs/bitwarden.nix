{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs'.bitwarden;
in {
  options.programs'.bitwarden = {
    enable = mkEnableOption "bitwarden";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      bitwarden-cli # bitwarden CLI app
    ];
  };
}
