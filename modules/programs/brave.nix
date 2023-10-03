{ config, lib, pkgs', user, ... }:
with lib;
let cfg = config.programs'.brave;
in {
  options.programs'.brave.enable = mkEnableOption "brave";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = [ pkgs'.brave ];
    };
  };
}
