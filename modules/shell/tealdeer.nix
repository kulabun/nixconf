{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.tealdeer;
in
{
  options.shell'.tealdeer.enable = mkEnableOption "tealdeer" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.tealdeer = {
        enable = true;
        settings = {
          display = {
            compact = false;
            use_pager = true;
          };
          updates = {
            auto_update = true;
          };
        };
      };
    };
  };
}

