{ config, lib, user, pkgs, ... }:
with lib;
let cfg = config.shell'.gcloud;
in {
  options.shell'.gcloud.enable = mkEnableOption "gcloud";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [ google-cloud-sdk ];
    };
  };
}
