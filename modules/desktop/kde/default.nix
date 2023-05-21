{ config, lib, pkgs, user, inputs, ... } @ attrs:
let
  cfg = config.desktop'.kde;
  configurationScript = import ./kde-config attrs;
in
with lib; {
  options.desktop'.kde.enable = mkEnableOption "kde";

  config = mkIf cfg.enable {
    shell'.gpg.pinentry = "qt";

    home-manager = {
      users.${user} = {
        home = {
          packages = [
            pkgs.dracula-theme
          ];

          # Hack to install configuration without making it immutable
          # Use `nixos-rebuild switch`, it will not be called for `boot`
          activation.kwriteconfig5 = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] configurationScript;
        };
      };
    };
  };
}
    
