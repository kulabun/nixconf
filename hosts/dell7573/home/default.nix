{ config
, pkgs
, ...
}: rec {
  imports = [ ../../../modules/home-manager ];
  
  settings = {
    user = "klabun";
    machine = "dell7590";
    secretsRootPath = "/home/klabun/secrets";
    cursor = {
      theme = "capitaine-cursors-white";
      size = 32;
    };

    fonts.enable = true;

    awscli2.enable = true;
    btop.enable = true;
    dev-tools.enable = true;
    # firefox.enable = false;
    fish.enable = true;
    gh.enable = true;
    git.enable = true;
    # go-chromecast.enable = true;
    # google-chrome.enable = false;
    google-cloud-sdk.enable = true;
    gpg.enable = true;
    gtk.enable = true;
    # helix.enable = false;
    home-manager.enable = true;
    jetbrains.idea-community.enable = true;
    kde.enable = true;
    kitty.enable = true;
    lorri.enable = true;
    navi.enable = true;
    neovim.default = true; # TODO: change it
    neovim.enable = true;
    qmk.enable = true;
    rclone.enable = true;
    scripts.enable = true;
    slack.enable = true;
    ssh.enable = true;
    taskwarrior.enable = true;
    terraform.enable = true;
    tig.enable = true;
    # ulauncher.enable = false; # broken on nixos
    vscode.enable = true;
    webapps.google-calendar.enable = true;
    webapps.google-docs.enable = true;
    webapps.google-drive.enable = true;
    webapps.google-keep.enable = true;
    webapps.google-mail.enable = true;
    webapps.google-meet.enable = true;
    # webapps.google-photos.enable = true;
    # webapps.youtube-music.enable = true;
    # webapps.messenger.enable = true;
    # webapps.telegram.enable = true;
    # webapps.whatsapp.enable = true;
    xdg.enable = true;
    zellij.enable = true;
    zoom-us.enable = true; # broken on sway
    zsh.enable = true;

    gtk.font = {
      name = "DejaVu Sans";
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
    stateVersion = "22.11";

    sessionVariables = {
      GDK_SCALE = 2;
      XCURSOR_SIZE = settings.cursor.size;
      XCURSOR_THEME = settings.cursor.theme;
    };
    packages = with pkgs; [ ];
  };

  programs = { ssh.includes = [ "${settings.secretsRootPath}/ssh/config" ]; };
}
