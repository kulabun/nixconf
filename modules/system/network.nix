{ config, lib, user, ... }:
with lib;
let cfg = config.system'.network;
in {
  options.system'.network = {
    enable = mkEnableOption "network config" // { default = true; };
  };

  config = mkIf cfg.enable {
    users.users.${user}.extraGroups = [ "networkmanager" ];

    # Required for chromecast https://github.com/NixOS/nixpkgs/issues/49630
    services.avahi.enable = true;

    networking = {
      networkmanager.enable = true;
      extraHosts = ''
        127.0.0.1 localhost
        192.168.1.101 hx90
        192.168.1.102 pbgo
        192.168.1.103 dell7573
        192.168.1.104 dell9360
        192.168.1.105 mba16
        192.168.1.106 dell5560
      '';
    };
  };
}
