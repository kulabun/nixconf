{ config
, pkgs
, lib
, ...
}:
let
  cheatsPath = "navi/cheats";
in
with lib; {
  options = {
    settings.navi.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables navi";
    };
  };

  config = mkIf config.settings.navi.enable {
    xdg.dataFile."navi/cheats/personal" = {
      source = ./cheats;
      recursive = true;
    };
    programs.navi = {
      enable = true;
      settings = { cheats = { }; };
    };
  };
}
