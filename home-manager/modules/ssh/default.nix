{ config, pkgs, lib, ... }: let
in{
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    #includes = [ "config.local" ];
  };
}
