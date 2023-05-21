{ config
, lib
, user
, pkgs'
, ...
}:
with lib; let
  cfg = config.shell'.broot;
in
{
  options.shell'.broot.enable = mkEnableOption "broot" // { default = true; };

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.broot = {
        enable = true;
        package = pkgs'.broot;
        settings = {
          default_flags = "sdp";
          show_selection_mark = true;
          max_panels_count = 2;
          modal = true;
          verbs = [
            {
              invocation = "edit";
              key = "enter";
              external = "$EDITOR {file}";
              leave_broot = false;
              apply_to = "file";
            }
          ];
        };
      };
    };
  };
}
