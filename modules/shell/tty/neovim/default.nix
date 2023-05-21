{ inputs
, config
, pkgs'
, lib
, ...
}:
with lib; {
  options = {
    settings.neovim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enables neovim";
      };
      default = mkOption {
        type = types.bool;
        default = false;
        description = "Set neovim as a default editor";
      };
    };
  };

  config = mkIf config.settings.neovim.enable {
    programs.zsh = {
      shellAliases = {
        vim = "nvim";
        vi = "vim";
      };
    } // optionalAttrs config.settings.neovim.default {
      sessionVariables = rec {
        EDITOR = "${pkgs'.neovim-kl}/bin/nvim";
        VISUAL = EDITOR;
        SUDOEDITOR = EDITOR;
      };
    };


    home = { packages = [ pkgs'.neovim-kl ]; };
  };
}
