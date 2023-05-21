{ config, lib, user, ... }:
with lib;
let
  cfg = config.hardware'.wifi;
in
{
  options.hardware'.wifi = {
    enable = mkEnableOption "WiFi support" // { default = true; };
  };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "networkmanager" ];

    networking.networkmanager.enable = true;
  };
}
