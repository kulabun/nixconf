{ config, lib, user, pkgs, inputs, ... }:
with lib;
let
  cfg = config.shell'.lazygit;
in
{
  options.shell'.lazygit.enable = mkEnableOption "lazygit" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.zsh = {
        shellAliases = {
          lg = "lazygit";
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          git.paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
        };
      };
    };
  };
}

