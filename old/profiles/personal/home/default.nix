{ config
, pkgs
, user
, host
, ...
}: rec {
  imports = [
    ../../../modules/home-manager
  ];

  settings = {
    secretsRootPath = "/home/${user}/secrets";

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
    # helix.enable = false;
    home-manager.enable = true;
    jetbrains.idea-community.enable = true;
    kde.enable = true;
    kitty.enable = true;
    lorri.enable = true;
    navi.enable = true;
    neovim.default = true;
    neovim.enable = true;
    qmk.enable = true;
    rclone.enable = true;
    scripts.enable = true;
    # slack.enable = false;
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
    webapps.google-photos.enable = true;
    webapps.youtube-music.enable = true;
    webapps.messenger.enable = true;
    webapps.telegram.enable = true;
    webapps.whatsapp.enable = true;
    webapps.poe.enable = true;
    xdg.enable = true;
    zellij.enable = true;
    zoom-us.enable = true; # broken on sway
    zsh.enable = true;
  };

  home = {
    packages = with pkgs; [ ];
  };

  programs = { ssh.includes = [ "${settings.secretsRootPath}/ssh/config" ]; };
}
