# Configuration is based on
#   https://github.com/LunNova/nixos-configs/blob/dev/users/lun/on-nixos/kdeconfig.nix
{ config, lib, pkgs, ... } @ attrs:
let
  configuration = import ./configuration.nix;
  writeConfigurationScript = import ./script.nix attrs;
in
(writeConfigurationScript configuration)

