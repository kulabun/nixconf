{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.gopass;
in
{
  options.shell'.gopass.enable = mkEnableOption "gopass";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ gopass ];
    };
  };
}

