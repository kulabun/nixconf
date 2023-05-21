{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.youtube-dl;
in
{
  options.shell'.youtube-dl.enable = mkEnableOption "youtube-dl";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ youtube-dl ];
    };
  };
}

