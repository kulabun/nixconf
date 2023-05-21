{ config
, pkgs
, lib
, ...
}:
with lib; {
  options = {
    settings.go-chromecast.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables go-chromecast";
    };
  };

  config = mkIf config.settings.go-chromecast.enable {
    home.packages = with pkgs; [ go-chromecast ];
  };
}
