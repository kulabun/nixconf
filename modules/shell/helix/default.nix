{ config, lib, user, pkgs', inputs, ... }:
with lib;
let
  cfg = config.shell'.helix;
in
{
  options.shell'.helix.enable = mkEnableOption "helix" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs'; [ helix ];
    };
  };
}

