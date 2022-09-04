{ config, pkgs, lib, ... }: {
  xdg.configFile = {
    "nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "NvChad";
        repo = "NvChad";
        rev = "b34328fb41be11f0ea56a1751e84020ef99ee608";
        sha256 = "0hfa2g1jp6b14m59dx5xvs555mbhpvg5nf5mg7vaing9c7cvfxy2";
      };
      recursive = true;
    };
    "nvim/lua/custom" = {
      source = ./config;
      recursive = true;
    };
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      neovim
      #tree-sitter
      nodejs

      # Python support
      nodePackages.pyright
      python3

      # Java support
      openjdk17
      jdt-language-server

      # Lua support
      sumneko-lua-language-server
      stylua
      luajit
      luajitPackages.luacheck

      # Nix support
      #nixpkgs-fmt
      nixfmt
      rnix-lsp

      # Rust support 
      cargo
      rustc
      rustfmt
      clippy # rust-linting
      rust-analyzer

      # Shell support
      nodePackages.bash-language-server
      shfmt
      shellcheck

      # JSON support
      nodePackages.vscode-json-languageserver
      jq

      # YAML support
      nodePackages.yaml-language-server
    ];
  };
}
