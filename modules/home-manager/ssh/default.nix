{
  config,
  pkgs,
  lib,
  mylib,
  ...
}: let
  cfg = config.settings;
in
  with lib;
  with mylib; {
    options = {
      settings.ssh.enable = mkEnableOpt "ssh";
    };

    config = mkIf config.settings.ssh.enable {
      programs.ssh = {
        enable = true;
        forwardAgent = true;
        matchBlocks."*".identitiesOnly = true;
        includes = [ "${cfg.secretsRootPath}/ssh/config" "~/.ssh/config.local" ];
        #includes = [ "config.local" ];
      };
    };
  }
