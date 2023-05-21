{ config, lib, pkgs', user, ... }:
with lib;
let cfg = config.programs'.obs-studio;
in {
  options.programs'.obs-studio.enable = mkEnableOption "OBS Studio";

  config = mkIf cfg.enable {
    boot = {
      kernelModules = [ "v4l2loopback" ];
      extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    };

    home-manager.users.${user} = {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs'; [
          obs-studio-plugins.wlrobs
          obs-studio-plugins.obs-vaapi
        ];
      };
    };
  };
}
