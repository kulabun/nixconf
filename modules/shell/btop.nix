{ config
, lib
, user
, pkgs
, ...
}:
with lib; let
  cfg = config.shell'.btop;
in
{
  options.shell'.btop.enable = mkEnableOption "btop" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ btop ];
    };
  };
}
