{
  inputs,
  system,
  config,
  pkgs,
  lib,
  mylib,
  ...
}:
with lib;
with mylib; {
  options = {
    settings.neovim.enable = mkEnableOpt "neovim";
  };

  config = mkIf config.settings.neovim.enable {
    xdg.configFile = {
      "nvim" = {
        source = pkgs.fetchFromGitHub {
          owner = "AstroNvim";
          repo = "AstroNvim";
          rev = "893665a969129eb528e54b7e4bee1e6c952d6d25";
          sha256 = "1wm4lpm3j4k6njf620ncq9gpy0zkrqgijzbg6y9jahb3wxl1qz15";
        };
        recursive = true;
      };
      "nvim/lua/user" = {
        # Unfortunately with Flakes ./config does not work as expected, so the url is provided as a string
        # https://github.com/nix-community/home-manager/issues/2085
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconf/modules/home-manager/neovim/config";
        #recursive = true;
      };
    };

    home = {
      # sessionVariables = {
      #   EDITOR = "nvim";
      #   VISUAL = "nvim";
      # };

      packages = let
        # my-rustc = pkgs.rustc.overrideAttrs (attrs: {
        #   postInstall = ''
        #     RUST_SRC_PATH=$out/lib/rustlib/src/rust
        #     mkdir -p $(dirname $RUST_SRC_PATH)
        #     ln -sf ${pkgs.rust.packages.stable.rustPlatform.rustcSrc} $RUST_SRC_PATH
        #   '';
        # });
        # my-rust-analyzer = pkgs.rust-analyzer.overrideAttrs (attrs: {
        #   buildInputs = [ pkgs.makeWrapper ];
        #   postInstall = ''
        #     wrapProgram "$out/bin/rust-analyzer" \
        #       --set-default RUST_SRC_PATH "${my-rustc}/lib/rustlib/src/rust/src"
        #   '';
        # });
        my-rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = ["rust-src"];
          targets = ["x86_64-unknown-linux-gnu"];
        };
        my-rust-analyzer = pkgs.symlinkJoin {
          name = "rust-analyzer";
          paths = [inputs.nixpkgs.legacyPackages.${system}.rust-analyzer];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/rust-analyzer \
              --set-default "RUST_SRC_PATH" "${my-rust}"
          '';
        };
      in
        with pkgs; [
          alacritty
          kitty
          neovim-nightly
          tree-sitter
          nodejs
          python3
          # neovide

          #--------------
          # C
          clang-tools

          # JSON
          gojq

          # HTML, CSS
          nodePackages.vscode-langservers-extracted
          nodePackages.prettier

          # Go
          go
          gopls

          # Rust
          my-rust
          my-rust-analyzer

          # Nix
          alejandra
          rnix-lsp
          statix

          # TOML
          taplo-cli

          # Shell
          nodePackages.bash-language-server
          shfmt
          shellcheck

          # YAML
          yaml-language-server

          # JavaScript / TypeScript
          nodePackages.typescript-language-server

          # Terraform
          terraform-ls

          # Python
          python3Packages.python-lsp-server
          black

          # Lua
          sumneko-lua-language-server
          stylua
          luajit
          luajitPackages.luacheck
        ];
    };
  };
}
