{
  inputs,
  system,
  config,
  pkgs,
  lib,
  mylib,
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
in
  with lib;
  with mylib; {
    options = {
      settings.helix.enable = mkEnableOpt "helix";
    };

    config = mkIf config.settings.helix.enable {
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

              # Quick iteration on config changes
              # C-o = ":config-open";
              # C-r = ":config-reload";

              # Some nice Helix stuff
              C-h = "select_prev_sibling";
              C-j = "shrink_selection";
              C-k = "expand_selection";
              C-l = "select_next_sibling";

              # Personal preference
              # o = ["open_below" "normal_mode"];
              # O = ["open_above" "normal_mode"];

              # Muscle memory
              "{" = ["goto_prev_paragraph" "collapse_selection"];
              "}" = ["goto_next_paragraph" "collapse_selection"];
              "0" = "goto_line_start";
              "$" = "goto_line_end";
              "^" = "goto_first_nonwhitespace";
              G = "goto_file_end";
              "%" = "match_brackets";
              V = ["select_mode" "extend_to_line_bounds"];
              C = ["collapse_selection" "extend_to_line_end" "change_selection"]; # Requires https://github.com/helix-editor/helix/issues/2051#issuecomment-1140358950
              D = ["extend_to_line_end" "delete_selection"];
              S = "surround_add"; # Would be nice to be able to do something after this but it isn't chainable

              # Extend and select commands that expect a manual input can't be chained
              # I've kept d[X] commands here because it's better to at least have the stuff you want to delete
              # selected so that it's just a keystroke away to delete
              # d = {
              #   d = ["extend_to_line_bounds" "delete_selection"];
              #   # t = ["extend_till_char" "delete_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              #   s = ["surround_delete"];
              #   # i = ["select_textobject_inner" "delete_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              #   # a = ["select_textobject_around" "delete_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              # };

              # c = {
              #   c = ["collapse_selection" "extend_to_line_end" "change_selection"];
              #   # t = ["extend_till_char" "change_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              #   s = ["surround_replace"];
              #   # i = ["select_textobject_inner" "change_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              #   # a = ["select_textobject_around" "change_selection"]; # Requires https://github.com/helix-editor/helix/issues/4013
              # };

              # Clipboards over registers ye ye
              x = "delete_selection";
              p = "paste_clipboard_after";
              P = "paste_clipboard_before";
              # Would be nice to add ya and yi but the surround commands can't be chained;
              y = ["yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection"];
              Y = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection"];

              # Uncanny valley stuff this makes w and b behave as they do Vim
              # w = ["move_next_word_start" "move_char_right" "collapse_selection"];
              # e = ["move_next_word_end" "collapse_selection"];
              # b = ["move_prev_word_start" "collapse_selection"];

              # If you want to keep the selection-while-moving behaviour of Helix this two lines will help a lot
              # especially if you find having text remain selected while you have switched to insert or append mode
              #
              # There is no real difference if you have overriden the commands bound to 'w' 'e' and 'b' like above
              # But if you really want to get familiar with the Helix way of selecting-while-moving comment the
              # bindings for 'w' 'e' and 'b' out and leave the bindings for 'i' and 'a' active below. A world of difference!
              i = ["insert_mode" "collapse_selection"]; # Requires https://github.com/helix-editor/helix/issues/2052#issuecomment-1140358950
              a = ["append_mode" "collapse_selection"]; # Requires https://github.com/helix-editor/helix/issues/2052#issuecomment-1140358950

              # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
              esc = ["collapse_selection" "keep_primary_selection"];
            };
            insert = {
              # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
              esc = ["collapse_selection" "normal_mode"];
            };
            select = {
              # Muscle memory
              "{" = ["extend_to_line_bounds" "goto_prev_paragraph"];
              "}" = ["extend_to_line_bounds" "goto_next_paragraph"];
              "0" = "goto_line_start";
              "$" = "goto_line_end";
              "^" = "goto_first_nonwhitespace";
              G = "goto_file_end";
              D = ["extend_to_line_bounds" "delete_selection" "normal_mode"];
              C = ["goto_line_start" "extend_to_line_bounds" "change_selection"];
              "%" = "match_brackets";
              S = "surround_add"; # Basically 99% of what I use vim-surround for
              V = ["extend_to_line_bounds"];

              # Visual-mode specific muscle memory
              i = "select_textobject_inner";
              a = "select_textobject_around";
              # x = "delete_selection";

              # Some extra binds to allow us to insert/append in select mode because it's nice with multiple cursors
              tab = ["insert_mode" "collapse_selection"]; # tab is read by most terminal editors as "C-i"
              C-a = ["append_mode" "collapse_selection"];

              # Make selecting lines in visual mode behave sensibly
              k = ["extend_line_up" "extend_to_line_bounds"];
              j = ["extend_line_down" "extend_to_line_bounds"];

              # Clipboards over registers ye ye
              d = ["yank_main_selection_to_clipboard" "delete_selection"];
              x = ["yank_main_selection_to_clipboard" "delete_selection"];
              y = ["yank_main_selection_to_clipboard" "normal_mode" "flip_selections" "collapse_selection"];
              Y = ["extend_to_line_bounds" "yank_main_selection_to_clipboard" "goto_line_start" "collapse_selection" "normal_mode"];
              p = "replace_selections_with_clipboard"; # No life without this
              P = "paste_clipboard_before";

              # Escape the madness! No more fighting with the cursor! Or with multiple cursors!
              esc = ["collapse_selection" "keep_primary_selection" "normal_mode"];
            };
          };
        };
      };
    };
  }
