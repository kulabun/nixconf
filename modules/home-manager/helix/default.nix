{
  inputs,
  system,
  config,
  pkgs,
  lib,
  ...
}: let
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
  my-helix = pkgs.helix.overrideAttrs (old: rec {
    version = "22.08.01";
    src = pkgs.fetchFromGitHub {
      owner = "helix-editor";
      repo = old.pname;
      rev = "${version}";
      fetchSubmodules = true;
      sha256 = "sha256-pqAhUxKeFN7eebVdNN3Ge38sA30SUSu4Xn4HDZAjjyY=";
    };
    cargoSha256 = "sha256-idItRkymr+cxk3zv2mPBR/frCGvzEUdSAhY7gghfR3M=";
    cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
      inherit src;
      name = "${old.pname}-vendor.tar.gz";
      outputHash = "sha256-V3be7onL/A4Ib9E2S6oW7HSE93jgKFSGZkf9m2BMs4w=";
    });
  });
in {
  home = {
    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    packages = let
    in
      with pkgs; [
        my-helix
        clang-tools
        gojq

        # HTML, CSS, JSON
        nodePackages.vscode-langservers-extracted

        # Go
        go
        gopls

        # Rust
        my-rust
        my-rust-analyzer

        # Nix
        alejandra
        rnix-lsp

        # TOML
        # taplo-cli

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
      ];
  };

  programs.helix = {
    enable = true;
    package = my-helix;
    languages = [
      {
        name = "nix";
        auto-format = true;
        formatter = {
          command = "${pkgs.alejandra}/bin/alejandra";
          args = ["--quiet"];
        };
      }

      {
        name = "html";
        file-types = ["html" "tmpl"];
      }

      {
        name = "toml";
        language-server = {command = "${pkgs.taplo-lsp}/bin/taplo";};
      }
    ];

    settings = {
      theme = "dracula";
      editor = {
        auto-format = true;
        auto-pairs = true;
        color-modes = true;
        completion-trigger-len = 1;
        cursorline = true;
        file-picker.hidden = false;
        idle-timeout = 0;
        line-number = "relative";
        lsp.display-messages = true;
        true-color = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };

        statusline = {
          left = ["mode"];
          center = ["file-name"];
          right = ["selections" "diagnostics" "spinner" "position-percentage"];
        };
      };

      keys = {
        normal = {
          Z = {Z = ":wq";};
          "=" = [":format"];
        };
        insert = {
        };
        select = {
        };
      };
    };
  };
}
