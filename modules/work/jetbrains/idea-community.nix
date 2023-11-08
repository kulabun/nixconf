{ config, lib, pkgs', user, inputs, ... }:
with lib;
let
  cfg = config.programs'.jetbrains.idea-community;

  inherit (config.home-manager.users.${user}.home) homeDirectory;

  idea-community = pkgs'.jetbrains.plugins.addPlugins pkgs'.jetbrains.idea-community [
    "ideavim"
  ];

  work-idea-community = pkgs'.symlinkJoin {
    name = "idea-community";
    paths = [ idea-community ];
    buildInputs = [ pkgs'.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/idea-community \
        --unset GDK_SCALE\
        --set INDEED_GLOBAL_DIR ${homeDirectory}/indeed/indeed\
        --set INDEED_PROJECT_DIR ${homeDirectory}/indeed/indeed\
        --set INDEED_JAVADEV_DIR ${homeDirectory}/indeed/indeed/javadev\
        --set INDEED_HOBO_DIR ${homeDirectory}/indeed/indeed/hobo\
        --set INDEED_CONFIG_DIR ${homeDirectory}/indeed/indeed/javadev/myconfig\
        --set JAVA_HOME ${homeDirectory}/.local/share/dev/sdks-work/zulu8\
        --set JAVA_HOME_8 ${homeDirectory}/.local/share/dev/sdks-work/zulu8\
        --set JAVA_HOME_11 ${homeDirectory}/.local/share/dev/sdks-work/zulu11\
        --set JAVA_HOME_17 ${homeDirectory}/.local/share/dev/sdks-work/zulu17
    '';
  };

  indeed-idea = pkgs'.makeDesktopItem {
    icon = "idea-community";
    name = "(NixOS) Indeed IntelliJ IDEA";
    genericName = "IDE";
    categories = [ "Development" "IDE" ];
    desktopName = "Indeed Idea(NixOS)";
    startupWMClass = "jetbrains-idea-ce";
    exec = "${work-idea-community}/bin/idea-community";
  };
in
{
  options.work'.jetbrains.idea-community.enable = mkEnableOption "(Indeed) JetBrains IntelliJ IDEA Community Edition";

  config = mkIf cfg.enable {
    home-manager.users.${user} = {
      home = {
        packages = [ indeed-idea ];
      };

      programs.zsh = {
        shellAliases = {
          indeed-idea = "${work-idea-community}/bin/idea-community";
        };
      };
    };
  };
}
