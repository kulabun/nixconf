{ config
, pkgs
, lib
, ...
}:
with lib; {
  options = {
    settings.qmk.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables qmk";
    };
  };

  config = mkIf config.settings.qmk.enable {
    xdg.configFile = {
      "qmk" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
