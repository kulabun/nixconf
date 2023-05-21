{ config, lib, user, pkgs, ... }:
with lib;
let cfg = config.shell'.awscli;
in {
  options.shell'.awscli.enable = mkEnableOption "awscli";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ awscli2 ];
    };
  };
}
