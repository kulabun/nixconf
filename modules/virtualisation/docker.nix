{ config, lib, pkgs, user, ... }:
with lib;
let cfg = config.virtualisation'.docker;
in {
  options.virtualisation'.docker.enable = mkEnableOption "docker";

  config = mkIf cfg.enable {
    users = {
      users.${user}.extraGroups = [ "docker" ];
    };

    virtualisation = {
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
      # podman = {
      #   enable = true;
      #   dockerCompat = true;
      #   dockerSocket.enable = true;
      #   autoPrune.enable = true;
      # };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };

}
