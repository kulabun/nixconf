{ inputs
, system
, config
, pkgs
, pkgs'
, lib
, mylib
, ...
}:
with lib;
with mylib; {
  options = {
    settings.neovim.enable = mkEnableOpt "neovim";
    settings.neovim.default = mkEnableOpt "neovim";
  };
  config = mkIf config.settings.neovim.enable {
    programs.zsh = {
      shellAliases = {
        vim = "nvim";
        vi = "vim";
      };
    } // optionalAttrs config.settings.neovim.default {
      sessionVariables = rec {
        EDITOR = "${pkgs.neovim-kl}/bin/nvim";
        VISUAL = EDITOR;
        SUDOEDITOR = EDITOR;
      };
    };


    home = { packages = [ pkgs.neovim-kl ]; };
  };
}
