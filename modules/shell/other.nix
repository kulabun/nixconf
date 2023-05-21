{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.other;
in
{
  options.shell'.other.enable = mkEnableOption "other";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs; [
        up # realtime preview for bash pipes evaluation
        psmisc # fuser.- helps to see what process blocks the file
        atool # archive tool
        unzip
        unrar
        vim # fallback if neovim is broken
        hyperfine # benchmarking tool

        fend # convert units
        fwup # firmware updater
      ];
    };
  };
}

