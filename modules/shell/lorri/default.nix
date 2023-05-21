{ config, lib, user, pkgs, ... }:
with lib;
let cfg = config.shell'.lorri;
in {
  options.shell'.lorri.enable = mkEnableOption "lorri";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home = { packages = with pkgs; [ direnv ]; };
      services = { lorri.enable = true; };
    };
  };
}
