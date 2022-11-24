{ inputs
, system
, config
, pkgs
, lib
, mylib
, ...
}:
with lib;
with mylib; {
  options = {
    settings.dev-tools.enable = mkEnableOpt "dev-tools";
  };

  config = mkIf config.settings.dev-tools.enable {
    xdg.dataFile = {
      "dev/sdks".source = pkgs.linkFarm "local-sdks" [
        {
          name = "go";
          path = pkgs.go;
        }
        {
          name = "python";
          path = pkgs.python3;
        }
        {
          name = "java8";
          path = pkgs.jdk8;
        }
        {
          name = "java11";
          path = pkgs.jdk11;
        }
        {
          name = "java17";
          path = pkgs.jdk17;
        }
        {
          name = "node";
          path = pkgs.nodejs;
        }
        #   {
        #     name = "rustc";
        #     path = pkgs.symlinkJoin {
        #       name = pkgs.rustc.pname;
        #       paths = [ pkgs.rustc pkgs.cargo pkgs.gcc ];
        #     };
        #   }
        #   {
        #     name = "rust-src";
        #     path = pkgs.rust.packages.stable.rustPlatform.rustLibSrc;
        #   }
      ];
    };

    home = {
      packages =
        let
          # my-rust = pkgs.rust-bin.stable.latest.default.override {
          #   extensions = ["rust-src"];
          #   targets = ["x86_64-unknown-linux-gnu"];
          # };
          # my-rust-analyzer = pkgs.symlinkJoin {
          #   name = "rust-analyzer";
          #   paths = [inputs.nixpkgs.legacyPackages.${system}.rust-analyzer];
          #   buildInputs = [pkgs.makeWrapper];
          #   postBuild = ''
          #     wrapProgram $out/bin/rust-analyzer \
          #       --set-default "RUST_SRC_PATH" "${my-rust}"
          #   '';
          # };
        in
        with pkgs; [
          # system-level sdks
          nodejs
          python3
          go
          # my-rust
          rustup

          # Required by some LSPs and editor plugins
          gcc
          gnumake
          pkg-config

          # tools
          ripgrep
          ripgrep-all # ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
          fd
          jq

          # Syntax highlighter
          tree-sitter

          # Language servers

          # C
          clang-tools

          # JSON
          gojq

          # HTML, CSS
          nodePackages.vscode-langservers-extracted
          nodePackages.prettier

          # Go
          gopls

          # Rust
          # my-rust-analyzer

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
          nodePackages.typescript
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
