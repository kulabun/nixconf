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
    settings.terraform.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables terraform.";
    };
  };

  config = mkIf config.settings.terraform.enable {
    home.packages = with pkgs; [ terraform ];
  };
}
