{ config
, pkgs
, ...
}: rec {
  imports = [ ../../../modules/home-manager ];

  settings = {
    user = "konstantin";
    machine = "hx90";
    secretsRootPath = "/home/konstantin/secrets";
  };

  home = {
    enableNixpkgsReleaseCheck = true;

    sessionVariables = {
      GDK_SCALE = 2;
      XCURSOR_SIZE = 128;
    };
    packages = with pkgs; [ ];

    # file = {
    #   #".config/ulauncher".source = ~/dotfiles/config/ulauncher;
    #   ".sdks/jdk8".source = pkgs.openjdk8;
    #   ".sdks/jdk11".source = pkgs.openjdk11;
    #   ".sdks/jdk17".source = pkgs.openjdk17;
    #   ".sdks/python38".source = pkgs.python38;
    #   ".sdks/python3".source = pkgs.python3;
    #   ".sdks/nodejs-16_x".source = pkgs.nodejs-16_x;
    # };
  };

  programs = { ssh.includes = [ "${settings.secretsRootPath}/ssh/config" ]; };

  wayland.windowManager.sway = {
    package = null; # Package is installed with nixos. Dont install duplicate.
    # Enable sway-session.target to link to graphical-session.target for systemd
  };
}
