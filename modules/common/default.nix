{
  pkgs,
  config,
  mylib,
  lib,
  ...
}:
with lib; {
  options.settings.extraSessionCommands = mkStrOpt;
}
