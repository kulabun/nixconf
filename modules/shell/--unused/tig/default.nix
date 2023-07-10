{ config
, pkgs
, lib
, ...
}:
let
  cfg = config.settings;
in
with lib; {
  options = {
    settings.tig.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables tig.";
    };
  };

  config = mkIf config.settings.tig.enable {
    home.packages = with pkgs; [ tig ];
  };
}
