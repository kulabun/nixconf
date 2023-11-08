{ config, lib, pkgs', user, inputs, ... }:
with lib;
let
  cfg = config.programs'.jetbrains.gateway;

  gateway = pkgs'.symlinkJoin {
    name = "gateway";
    paths = [
      (pkgs'.jetbrains.gateway.overrideAttrs (old: {
        src = pkgs'.fetchurl {
          url = "https://download.jetbrains.com/idea/gateway/JetBrainsGateway-2023.2.4.tar.gz";
          sha256 = "sha256-C5zxAunR6su9hGEGFFQE+UTkxtbiVIvDRzSkHEqfIOg=";
        };
      }))
    ];
    buildInputs = [ pkgs'.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/gateway --unset GDK_SCALE --set JETBRAINS_CLIENT_JDK "${pkgs'.jetbrains.jdk.home}"
      # wrapProgram $out/bin/gateway --set GDK_SCALE 2
    '';
  };
in
{
  options.programs'.jetbrains.gateway.enable = mkEnableOption "JetBrains Gateway";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home = {
        packages = [ gateway ];

        file.ideavimrc = {
          source = ./config/ideavimrc;
          target = ".ideavimrc";
        };
      };

      programs.zsh = {
        shellAliases = {
          gateway = "${gateway}/bin/gateway";
        };
      };
    };
  };
}
