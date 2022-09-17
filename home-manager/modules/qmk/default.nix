{ config, pkgs, ... }: {
  xdg.configFile = {
    "qmk" = {
      source = ./config;
      recursive = true;
    };
  };
}

