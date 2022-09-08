{  config, pkgs, lib, ... }: {
  xdg.configFile = {
    "helix" = {
      source = ./config;
      recursive = true;
    };
  };

  home = {
    packages = with pkgs; [
        helix
    ];
  };
}
