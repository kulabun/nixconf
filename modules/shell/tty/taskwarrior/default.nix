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
    settings.taskwarrior.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables taskwarrior.";
    };
  };

  config = mkIf config.settings.taskwarrior.enable {
    programs = { taskwarrior.enable = true; };
  };
}
