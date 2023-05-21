{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.wl-clipboard;
in
{
  options.shell'.wl-clipboard.enable = mkEnableOption "wl-clipboard" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ wl-clipboard ];
    };
  };
}

