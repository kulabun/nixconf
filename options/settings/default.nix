{ pkgs, config, lib, ... }:

with lib; {
  options.nixconf.settings = {
    secretsRootPath = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        Path to secrets root
      '';
    };

    user = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        The user name
      '';
    };
    
    machine = mkOption {
      type = types.str;
      readOnly = true;
      description = ''
        The machine name
      '';
    };

    programs = {
      foot.font = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            The font name
          '';
        };
        size = mkOption {
          type = types.int;
          readOnly = true;
          description = ''
            The font size
          '';
        };
      };

      waybar.font = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            The font name
          '';
        };

        size = mkOption {
          type = types.int;
          readOnly = true;
          description = ''
            The font size
          '';
        };
      };

      sway.font = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            The font name
          '';
        };

        size = mkOption {
          type = types.int;
          readOnly = true;
          description = ''
            The font size
          '';
        };
      };

      rofi.font = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            The font name
          '';
        };

        size = mkOption {
          type = types.int;
          readOnly = true;
          description = ''
            The font size
          '';
        };
      };

      mako.font = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            The font name
          '';
        };

        size = mkOption {
          type = types.int;
          readOnly = true;
          description = ''
            The font size
          '';
        };
      };
    };
  };
}
