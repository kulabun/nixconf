{ config, lib, pkgs', user, inputs, ... }:
with lib;
let
  cfg = config.programs'.jetbrains.idea-community;

  jetbrains-pkgs = import inputs.nixpkgs-jetbrains { system = pkgs'.system; };

  copilot-plugin = import ./copilot-plugin.nix { inherit jetbrains-pkgs lib; pkgs = pkgs'; };
  plugins = jetbrains-pkgs.jetbrains.plugins;
  withCopilot = ide: plugins.addPlugins ide [ copilot-plugin ];
  idea-community = withCopilot (jetbrains-pkgs.jetbrains.idea-community.override {
    jdk = pkgs'.jetbrains.jdk;
  });
  # idea-community = jetbrains-pkgs.jetbrains.idea-community;

  my-idea-community = pkgs'.symlinkJoin {
    name = "idea-community";
    paths = [ idea-community ];
    buildInputs = [ pkgs'.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/idea-community --unset GDK_SCALE
      # wrapProgram $out/bin/idea-community --set GDK_SCALE 2
    '';
  };
in
{
  options.programs'.jetbrains.idea-community.enable = mkEnableOption "JetBrains IntelliJ IDEA Community Edition";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home = {
        packages = [ my-idea-community ];

        file.ideavimrc = {
          source = ./config/ideavimrc;
          target = ".ideavimrc";
        };
      };

      programs.zsh = {
        shellAliases = {
          idea = "${my-idea-community}/bin/idea-community";
        };
      };
    };
  };
}
