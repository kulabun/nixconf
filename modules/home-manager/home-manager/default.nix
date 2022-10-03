{
  config,
  pgks,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.home-manager.enable = mkEnableOpt "home-manager";
  };

  config = mkIf config.settings.home-manager.enable {
    programs = {home-manager.enable = true;};

    manual = {
      html.enable = true;
      json.enable = true;
    };
  };
}
