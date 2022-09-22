{ config, pkgs, lib, ... }: let
in{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    matchBlocks."*".identitiesOnly = true;
    #includes = [ "config.local" ];
  };
}
