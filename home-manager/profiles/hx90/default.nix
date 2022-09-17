{ config, pkgs, ... }:
let cfg = config.nixconf.settings;
in {
  imports = [ ../../modules/default ];
  home = {
    enableNixpkgsReleaseCheck = true;

    packages = with pkgs; [ ];

    file = {
      #".config/ulauncher".source = ~/dotfiles/config/ulauncher;
      ".sdks/jdk8".source = pkgs.openjdk8;
      ".sdks/jdk11".source = pkgs.openjdk11;
      ".sdks/jdk17".source = pkgs.openjdk17;
      ".sdks/python38".source = pkgs.python38;
      ".sdks/python3".source = pkgs.python3;
      ".sdks/nodejs-16_x".source = pkgs.nodejs-16_x;
    };
  };

  programs = { ssh.includes = [ "${cfg.secretsRootPath}/ssh/config" ]; };
}

