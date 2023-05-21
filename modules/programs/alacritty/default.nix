{ config, lib, user, pkgs, inputs, ... }:
with lib;
let
  cfg = config.programs'.alacritty;
  alacritty_themes = inputs.alacritty-theme;
  catppuccin_theme = inputs.catppuccin-alacritty;
  inherit (cfg) font;
in
{
  options.programs'.alacritty = {
    enable = mkEnableOption "alacritty";
    font = {
      name = mkOption {
        type = types.str;
        description = "Font name to use in alacritty.";
      };
      size = mkOption {
        type = types.int;
        description = "Font size to use in alacritty.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.variables = {
      TERMINAL = "alacritty";
    };

    home-manager.users.${user} = {
      xdg.configFile."alacritty/themes" = {
        source = "${alacritty_themes}/themes";
        recursive = true;
      };
      xdg.configFile."alacritty/themes/catppuccin" = {
        source = catppuccin_theme;
        recursive = true;
      };

      programs.alacritty = {
        enable = true;
        settings = {
          /* import = [ "${config.home-manager.users.${user}.xdg.configHome}/alacritty/themes/one_dark.yaml" ]; */
          import = [ "${config.home-manager.users.${user}.xdg.configHome}/alacritty/themes/catppuccin/catppuccin-mocha.yml" ];
          shell = {
            program = if config.shell'.zsh.enable then "zsh" else "bash";
            # KDE tiling doesn't work well with zellij being started instead of shell. Without the delay Zellij ends up being scaled on half of the terminal only.
            args = [ ] ++ (if config.shell'.zellij.enable then [ "-c" "echo starting zellij..; sleep 0.1; zellij" ] else [ ]);
          };
          env = {
            TERM = "alacritty";
          };
          font = {
            normal.family = cfg.font.name;
            size = cfg.font.size;
          };
          key_bindings = [
            # { key = "V"; mods = "Control"; action = "Paste"; }
            # { key = "V"; mods = "Control|Shift"; chars = "\\x16"; }
            # { key = "C"; mods = "Control"; action = "Copy"; }
            # { key = "C"; mods = "Control|Shift"; chars = "\\x03"; }

            # https://www.reddit.com/r/neovim/comments/mbj8m5/how_to_setup_ctrlshiftkey_mappings_in_neovim_and/ 
            # The escape sequence is made of the following parts:
            # - \x1b[ is a CSI (control sequence introducer), meaning ESC+[;
            # - 74 is the decimal value of char J (see above);
            # - 5 is the sum of bits for the ctrl and shift modifiers (1 is shift, 2 is alt, 4 is ctrl);
            # - u stands for unicode.

            # https://stackoverflow.com/questions/8033779/is-there-a-way-to-map-ctrl-period-and-ctrl-comma-in-vim 
            # Comma, Period, Space, Insert don't work with Control, Alt. 

            /* { key = "At"; mods = "Control"; chars = "\\x1b[64;4u"; } */

            # Generally in terminals Enter is Ctrl-M. While Ctrl-Enter sometimes is Ctrl-J. 
            # Alacritty do have a mapping for Enter, but Ctrl-Enter sends the same Ctrl-M.
            { key = "Return"; mods = "Control|Shift"; chars = "\\x1b[13;6u"; }
            { key = "Return"; mods = "Control"; chars = "\\x1b[13;5u"; }

            { key = "A"; mods = "Control|Shift"; chars = "\\x1b[65;5u"; }
            { key = "B"; mods = "Control|Shift"; chars = "\\x1b[66;5u"; }
            # { key = "C"; mods = "Control|Shift"; chars = "\\x1b[67;5u"; }
            { key = "C"; mods = "Control|Shift"; chars = "Copy"; }
            { key = "D"; mods = "Control|Shift"; chars = "\\x1b[68;5u"; }
            { key = "E"; mods = "Control|Shift"; chars = "\\x1b[69;5u"; }
            { key = "F"; mods = "Control|Shift"; chars = "\\x1b[70;5u"; }
            { key = "G"; mods = "Control|Shift"; chars = "\\x1b[71;5u"; }
            { key = "H"; mods = "Control|Shift"; chars = "\\x1b[72;5u"; }
            { key = "I"; mods = "Control|Shift"; chars = "\\x1b[73;5u"; }
            { key = "J"; mods = "Control|Shift"; chars = "\\x1b[74;5u"; }
            { key = "K"; mods = "Control|Shift"; chars = "\\x1b[75;5u"; }
            { key = "L"; mods = "Control|Shift"; chars = "\\x1b[76;5u"; }
            { key = "M"; mods = "Control|Shift"; chars = "\\x1b[77;5u"; }
            { key = "N"; mods = "Control|Shift"; chars = "\\x1b[78;5u"; }
            { key = "O"; mods = "Control|Shift"; chars = "\\x1b[79;5u"; }
            { key = "P"; mods = "Control|Shift"; chars = "\\x1b[80;5u"; }
            { key = "Q"; mods = "Control|Shift"; chars = "\\x1b[81;5u"; }
            { key = "R"; mods = "Control|Shift"; chars = "\\x1b[82;5u"; }
            { key = "S"; mods = "Control|Shift"; chars = "\\x1b[83;5u"; }
            { key = "T"; mods = "Control|Shift"; chars = "\\x1b[84;5u"; }
            { key = "U"; mods = "Control|Shift"; chars = "\\x1b[85;5u"; }
            # { key = "V"; mods = "Control|Shift"; chars = "\\x1b[86;5u"; }
            { key = "V"; mods = "Control|Shift"; chars = "Paste"; }
            { key = "W"; mods = "Control|Shift"; chars = "\\x1b[87;5u"; }
            { key = "X"; mods = "Control|Shift"; chars = "\\x1b[88;5u"; }
            { key = "Y"; mods = "Control|Shift"; chars = "\\x1b[89;5u"; }
            { key = "Z"; mods = "Control|Shift"; chars = "\\x1b[90;5u"; }
            { key = "Key0"; mods = "Control|Shift"; chars = "\\x1b[48;5u"; }
            { key = "Key1"; mods = "Control|Shift"; chars = "\\x1b[49;5u"; }
            { key = "Key2"; mods = "Control|Shift"; chars = "\\x1b[50;5u"; }
            { key = "Key3"; mods = "Control|Shift"; chars = "\\x1b[51;5u"; }
            { key = "Key4"; mods = "Control|Shift"; chars = "\\x1b[52;5u"; }
            { key = "Key5"; mods = "Control|Shift"; chars = "\\x1b[53;5u"; }
            { key = "Key6"; mods = "Control|Shift"; chars = "\\x1b[54;5u"; }
            { key = "Key7"; mods = "Control|Shift"; chars = "\\x1b[55;5u"; }
            { key = "Key8"; mods = "Control|Shift"; chars = "\\x1b[56;5u"; }
            { key = "Key9"; mods = "Control|Shift"; chars = "\\x1b[57;5u"; }

            { key = "A"; mods = "Alt|Shift"; chars = "\\x1b[65;3u"; }
            { key = "B"; mods = "Alt|Shift"; chars = "\\x1b[66;3u"; }
            { key = "C"; mods = "Alt|Shift"; chars = "\\x1b[67;3u"; }
            { key = "D"; mods = "Alt|Shift"; chars = "\\x1b[68;3u"; }
            { key = "E"; mods = "Alt|Shift"; chars = "\\x1b[69;3u"; }
            { key = "F"; mods = "Alt|Shift"; chars = "\\x1b[70;3u"; }
            { key = "G"; mods = "Alt|Shift"; chars = "\\x1b[71;3u"; }
            { key = "H"; mods = "Alt|Shift"; chars = "\\x1b[72;3u"; }
            { key = "I"; mods = "Alt|Shift"; chars = "\\x1b[73;3u"; }
            { key = "J"; mods = "Alt|Shift"; chars = "\\x1b[74;3u"; }
            { key = "K"; mods = "Alt|Shift"; chars = "\\x1b[75;3u"; }
            { key = "L"; mods = "Alt|Shift"; chars = "\\x1b[76;3u"; }
            { key = "M"; mods = "Alt|Shift"; chars = "\\x1b[77;3u"; }
            { key = "N"; mods = "Alt|Shift"; chars = "\\x1b[78;3u"; }
            { key = "O"; mods = "Alt|Shift"; chars = "\\x1b[79;3u"; }
            { key = "P"; mods = "Alt|Shift"; chars = "\\x1b[80;3u"; }
            { key = "Q"; mods = "Alt|Shift"; chars = "\\x1b[81;3u"; }
            { key = "R"; mods = "Alt|Shift"; chars = "\\x1b[82;3u"; }
            { key = "S"; mods = "Alt|Shift"; chars = "\\x1b[83;3u"; }
            { key = "T"; mods = "Alt|Shift"; chars = "\\x1b[84;3u"; }
            { key = "U"; mods = "Alt|Shift"; chars = "\\x1b[85;3u"; }
            { key = "V"; mods = "Alt|Shift"; chars = "\\x1b[86;3u"; }
            { key = "W"; mods = "Alt|Shift"; chars = "\\x1b[87;3u"; }
            { key = "X"; mods = "Alt|Shift"; chars = "\\x1b[88;3u"; }
            { key = "Y"; mods = "Alt|Shift"; chars = "\\x1b[89;3u"; }
            { key = "Z"; mods = "Alt|Shift"; chars = "\\x1b[90;3u"; }
            { key = "Key0"; mods = "Alt|Shift"; chars = "\\x1b[48;3u"; }
            { key = "Key1"; mods = "Alt|Shift"; chars = "\\x1b[49;3u"; }
            { key = "Key2"; mods = "Alt|Shift"; chars = "\\x1b[50;3u"; }
            { key = "Key3"; mods = "Alt|Shift"; chars = "\\x1b[51;3u"; }
            { key = "Key4"; mods = "Alt|Shift"; chars = "\\x1b[52;3u"; }
            { key = "Key5"; mods = "Alt|Shift"; chars = "\\x1b[53;3u"; }
            { key = "Key6"; mods = "Alt|Shift"; chars = "\\x1b[54;3u"; }
            { key = "Key7"; mods = "Alt|Shift"; chars = "\\x1b[55;3u"; }
            { key = "Key8"; mods = "Alt|Shift"; chars = "\\x1b[56;3u"; }
            { key = "Key9"; mods = "Alt|Shift"; chars = "\\x1b[57;3u"; }

            { key = "A"; mods = "Control|Alt"; chars = "\\x1b[65;6u"; }
            { key = "B"; mods = "Control|Alt"; chars = "\\x1b[66;6u"; }
            { key = "C"; mods = "Control|Alt"; chars = "\\x1b[67;6u"; }
            { key = "D"; mods = "Control|Alt"; chars = "\\x1b[68;6u"; }
            { key = "E"; mods = "Control|Alt"; chars = "\\x1b[69;6u"; }
            { key = "F"; mods = "Control|Alt"; chars = "\\x1b[70;6u"; }
            { key = "G"; mods = "Control|Alt"; chars = "\\x1b[71;6u"; }
            { key = "H"; mods = "Control|Alt"; chars = "\\x1b[72;6u"; }
            { key = "I"; mods = "Control|Alt"; chars = "\\x1b[73;6u"; }
            { key = "J"; mods = "Control|Alt"; chars = "\\x1b[74;6u"; }
            { key = "K"; mods = "Control|Alt"; chars = "\\x1b[75;6u"; }
            { key = "L"; mods = "Control|Alt"; chars = "\\x1b[76;6u"; }
            { key = "M"; mods = "Control|Alt"; chars = "\\x1b[77;6u"; }
            { key = "N"; mods = "Control|Alt"; chars = "\\x1b[78;6u"; }
            { key = "O"; mods = "Control|Alt"; chars = "\\x1b[79;6u"; }
            { key = "P"; mods = "Control|Alt"; chars = "\\x1b[80;6u"; }
            { key = "Q"; mods = "Control|Alt"; chars = "\\x1b[81;6u"; }
            { key = "R"; mods = "Control|Alt"; chars = "\\x1b[82;6u"; }
            { key = "S"; mods = "Control|Alt"; chars = "\\x1b[83;6u"; }
            { key = "T"; mods = "Control|Alt"; chars = "\\x1b[84;6u"; }
            { key = "U"; mods = "Control|Alt"; chars = "\\x1b[85;6u"; }
            { key = "V"; mods = "Control|Alt"; chars = "\\x1b[86;6u"; }
            { key = "W"; mods = "Control|Alt"; chars = "\\x1b[87;6u"; }
            { key = "X"; mods = "Control|Alt"; chars = "\\x1b[88;6u"; }
            { key = "Y"; mods = "Control|Alt"; chars = "\\x1b[89;6u"; }
            { key = "Z"; mods = "Control|Alt"; chars = "\\x1b[90;6u"; }
            { key = "Key0"; mods = "Control|Alt"; chars = "\\x1b[48;6u"; }
            { key = "Key1"; mods = "Control|Alt"; chars = "\\x1b[49;6u"; }
            { key = "Key2"; mods = "Control|Alt"; chars = "\\x1b[50;6u"; }
            { key = "Key3"; mods = "Control|Alt"; chars = "\\x1b[51;6u"; }
            { key = "Key4"; mods = "Control|Alt"; chars = "\\x1b[52;6u"; }
            { key = "Key5"; mods = "Control|Alt"; chars = "\\x1b[53;6u"; }
            { key = "Key6"; mods = "Control|Alt"; chars = "\\x1b[54;6u"; }
            { key = "Key7"; mods = "Control|Alt"; chars = "\\x1b[55;6u"; }
            { key = "Key8"; mods = "Control|Alt"; chars = "\\x1b[56;6u"; }
            { key = "Key9"; mods = "Control|Alt"; chars = "\\x1b[57;6u"; }

            { key = "A"; mods = "Control|Alt|Shift"; chars = "\\x1b[65;7u"; }
            { key = "B"; mods = "Control|Alt|Shift"; chars = "\\x1b[66;7u"; }
            { key = "C"; mods = "Control|Alt|Shift"; chars = "\\x1b[67;7u"; }
            { key = "D"; mods = "Control|Alt|Shift"; chars = "\\x1b[68;7u"; }
            { key = "E"; mods = "Control|Alt|Shift"; chars = "\\x1b[69;7u"; }
            { key = "F"; mods = "Control|Alt|Shift"; chars = "\\x1b[70;7u"; }
            { key = "G"; mods = "Control|Alt|Shift"; chars = "\\x1b[71;7u"; }
            { key = "H"; mods = "Control|Alt|Shift"; chars = "\\x1b[72;7u"; }
            { key = "I"; mods = "Control|Alt|Shift"; chars = "\\x1b[73;7u"; }
            { key = "J"; mods = "Control|Alt|Shift"; chars = "\\x1b[74;7u"; }
            { key = "K"; mods = "Control|Alt|Shift"; chars = "\\x1b[75;7u"; }
            { key = "L"; mods = "Control|Alt|Shift"; chars = "\\x1b[76;7u"; }
            { key = "M"; mods = "Control|Alt|Shift"; chars = "\\x1b[77;7u"; }
            { key = "N"; mods = "Control|Alt|Shift"; chars = "\\x1b[78;7u"; }
            { key = "O"; mods = "Control|Alt|Shift"; chars = "\\x1b[79;7u"; }
            { key = "P"; mods = "Control|Alt|Shift"; chars = "\\x1b[80;7u"; }
            { key = "Q"; mods = "Control|Alt|Shift"; chars = "\\x1b[81;7u"; }
            { key = "R"; mods = "Control|Alt|Shift"; chars = "\\x1b[82;7u"; }
            { key = "S"; mods = "Control|Alt|Shift"; chars = "\\x1b[83;7u"; }
            { key = "T"; mods = "Control|Alt|Shift"; chars = "\\x1b[84;7u"; }
            { key = "U"; mods = "Control|Alt|Shift"; chars = "\\x1b[85;7u"; }
            { key = "V"; mods = "Control|Alt|Shift"; chars = "\\x1b[86;7u"; }
            { key = "W"; mods = "Control|Alt|Shift"; chars = "\\x1b[87;7u"; }
            { key = "X"; mods = "Control|Alt|Shift"; chars = "\\x1b[88;7u"; }
            { key = "Y"; mods = "Control|Alt|Shift"; chars = "\\x1b[89;7u"; }
            { key = "Z"; mods = "Control|Alt|Shift"; chars = "\\x1b[90;7u"; }
            { key = "Key0"; mods = "Control|Alt|Shift"; chars = "\\x1b[48;7u"; }
            { key = "Key1"; mods = "Control|Alt|Shift"; chars = "\\x1b[49;7u"; }
            { key = "Key2"; mods = "Control|Alt|Shift"; chars = "\\x1b[50;7u"; }
            { key = "Key3"; mods = "Control|Alt|Shift"; chars = "\\x1b[51;7u"; }
            { key = "Key4"; mods = "Control|Alt|Shift"; chars = "\\x1b[52;7u"; }
            { key = "Key5"; mods = "Control|Alt|Shift"; chars = "\\x1b[53;7u"; }
            { key = "Key6"; mods = "Control|Alt|Shift"; chars = "\\x1b[54;7u"; }
            { key = "Key7"; mods = "Control|Alt|Shift"; chars = "\\x1b[55;7u"; }
            { key = "Key8"; mods = "Control|Alt|Shift"; chars = "\\x1b[56;7u"; }
            { key = "Key9"; mods = "Control|Alt|Shift"; chars = "\\x1b[57;7u"; }
          ];
        };
      };
    };
  };
}
