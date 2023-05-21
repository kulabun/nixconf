{ config, lib, user, pkgs', inputs, ... }:
with lib;
let
  cfg = config.shell'.neovim;
in
{
  options.shell'.neovim.enable = mkEnableOption "neovim" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home.packages = with pkgs'; [ kl-nvim ];

      programs.zsh = {
        shellAliases = {
          vim = "nvim";
          vi = "vim";
        };
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      /* programs.neovim = { */
      /*   enable = true; */
      /*   package = pkgs'.kl-nvim; */
      /* }; */
    };
  };
}

