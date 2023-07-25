{ config, lib, user, pkgs', inputs, ... }:
with lib;
let
  cfg = config.shell'.zellij;
in
{
  options.shell'.zellij.enable = mkEnableOption "zellij" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs'; [ zellij ];
      xdg.configFile."zellij/config.kdl".source = ./config/config.kdl;
      xdg.configFile."zellij/layouts" = {
        source = ./config/layouts;
        recursive = true;
      };
    };
  };
}
