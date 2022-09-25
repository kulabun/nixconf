{ inputs, system, config, pkgs, lib, ... }: {
  xdg.configFile = {
    "nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "NvChad";
        repo = "NvChad";
        rev = "27560319cc4cf753e5a4d8713f82206d84a70d61";
        sha256 = "0aw41nm81897k444k7v4pxd0x390532vm1n3b82gdxqag7hvywg7";
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
        extensions = [ "rust-src" ];
        targets = [ "x86_64-unknown-linux-gnu" ];
      };
      my-rust-analyzer = (pkgs.symlinkJoin {
        name = "rust-analyzer";
        paths = [ inputs.nixpkgs.legacyPackages.${system}.rust-analyzer ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/rust-analyzer \
            --set-default "RUST_SRC_PATH" "${my-rust}"
        '';
      });
    in with pkgs; [
      neovim
      tree-sitter
      nodejs

      # Python support
      nodePackages.pyright
      python3

      # Java support
      # openjdk17
      # jdt-language-server

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
      # rustup
      my-rust
      my-rust-analyzer
      #cargo
      #rustfmt
      #clippy # rust-linting
      # my-rust
      # my-rust-analyzer
      taplo-lsp # toml support

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
