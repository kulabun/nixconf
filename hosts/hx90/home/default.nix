{ config
, pkgs
, ...
}: rec {
  imports = [ ../../../modules/home-manager ];

  settings = {
    user = "konstantin";
    machine = "hx90";
    secretsRootPath = "/home/konstantin/secrets";

    editor = "nvim";

    fonts.enable = true;

    awscli2.enable = true;
    btop.enable = true;
    dev-tools.enable = true;
    # firefox.enable = false;
    fish.enable = true;
    flameshot.enable = true;
    gh.enable = true;
    git.enable = true;
    go-chromecast.enable = true;
    # google-chrome.enable = false;
    google-cloud-sdk.enable = true;
    gpg.enable = true;
    gtk.enable = true;
    # helix.enable = false;
    home-manager.enable = true;
    jetbrains = {
      idea-community.enable = true;
    };
    kitty.enable = true;
    lorri.enable = true;
    navi.enable = true;
    neovim.enable = true;
    qmk.enable = true;
    rclone.enable = true;
    rofi.enable = true;
    scripts.enable = true;
    # slack.enable = false;
    ssh.enable = true;
    taskwarrior.enable = true;
    terraform.enable = true;
    tig.enable = true;
    # ulauncher.enable = false; # broken on nixos
    vscode.enable = true;
    webapps.google-calendar.enable = true;
    webapps.google-drive.enable = true;
    webapps.google-keep.enable = true;
    webapps.google-mail.enable = true;
    webapps.google-photos.enable = true;
    webapps.telegram.enable = true;
    webapps.whatsapp.enable = true;
    xdg.enable = true;
    # zoom-us.enable = false; # broken on wayland
    zsh.enable = true;

    sway.enable = true;
    waybar.enable = true;
    swayidle.enable = true;
    swaylock.enable = true;
    mako.enable = true;
    foot.enable = true;

    sway = {
      terminal = "${pkgs.foot}/bin/footclient";
      # terminal = "${pkgs.kitty}/bin/kitty";
    };

    sway.font = {
      name = "SauceCodePro Nerd Font";
      size = 9;
    };
    foot.font = {
      name = "SauceCodePro Nerd Font";
      size = 9;
    };
    kitty.font = {
      name = "SauceCodePro Nerd Font";
      size = 9;
    };
    waybar.font = {
      name = "SauceCodePro Nerd Font";
      size = 10;
    };
    rofi.font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };
    mako.font = {
      name = "JetBrainsMono Nerd Font";
      size = 9;
    };
    vscode.font = {
      name = "SauceCodePro Nerd Font";
      size = 12;
    };
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
