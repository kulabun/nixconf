{ lib, ... }:
let
  fileNames = with builtins;
    map (n: ./${n}) (filter (n: n != "default.nix") (attrNames (readDir ./.)));
in
with lib;
{
  imports = fileNames;

  hardware.bluetooth.enable = mkDefault true;

  # brightness control
  programs.light.enable = true;
}
