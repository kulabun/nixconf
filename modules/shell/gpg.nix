{ config, lib, user, pkgs, ... }:
with lib;
let
  cfg = config.shell'.gpg;
  kde = config.desktop'.kde;
in
{
  options.shell'.gpg.enable = mkEnableOption "gpg" // { default = true; };
  options.shell'.gpg.pinentry = mkOption {
    type = types.str;
    default = "curses";
  };

  config = mkIf cfg.enable (
    mkMerge [
      {
        home-manager.users.${user} = {
          programs.gpg.enable = true;
          services.gpg-agent.enable = true;
        };
      }

      (mkIf (cfg.pinentry == "qt")
        {
          home-manager.users.${user} = {
            home.packages = with pkgs; [ pinentry-qt ];
            services.gpg-agent.pinentryFlavor = "qt";
          };
        }
      )

      (mkIf (cfg.pinentry == "curses")
        {
          home-manager.users.${user} = {
            home.packages = with pkgs; [ pinentry-curses ];
            services.gpg-agent.pinentryFlavor = "curses";
          };
        }
      )
    ]
  );
}
