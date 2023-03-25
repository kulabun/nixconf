{ config
, pkgs
, pkgs'
, mylib
, user
, ...
}:
let
  cfg = config.settings;
  # cvm = pkgs.writeShellScriptBin "cvm" (builtins.readFile ./scripts/cvm.sh);
  gr = pkgs.writeShellScriptBin "gr" (builtins.readFile ./scripts/gr.sh);
  venv = pkgs.writeShellScriptBin "venv" (builtins.readFile ./scripts/venv.sh);
  none = pkgs.writeShellScriptBin "none" "echo none";
  # fix-ubuntu-sway = pkgs.writeShellScriptBin "fix-ubuntu-sway" (builtins.readFile ./scripts/fix-ubuntu-sway.sh);

  # slack-webapp = mylib.makeWebApp {
  #   name = "slack";
  #   desktopName = "Slack - Indeed PTE";
  #   url = "https://app.slack.com/client/T029BFEQ3/C029BFEQR";
  #   icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/com.slack.Slack.png";
  # };
in
{
  # Should be enabled if home-manager is running on Non-NixOS Linux
  targets.genericLinux.enable = true;

  imports = [ ../../../modules/home-manager ];


  home = {
    stateVersion = "22.11";
    enableNixpkgsReleaseCheck = true;
    homeDirectory = "/home/${user}";
    username = "${user}";
    packages = with pkgs; [
      consul
      vault
      gcc
      # cvm
      gr
      venv
      # fix-ubuntu-sway
      # slack-webapp
      insomnia
    ];
    # packages = with pkgs; [ consul vault gcc cvm gr venv fix-ubuntu-sway xwayland wlroots glib wayland ];
    # packages = with pkgs; [ consul vault gcc cvm gr venv fix-ubuntu-sway xwayland wlroots glib wayland xdg-desktop-portal-wlr xdg-desktop-portal-gtk xorg.xprop pipewire pipewire-media-session ];
  };

  settings = {
    secretsRootPath = "/home/${user}/secrets";

    awscli2.enable = true;
    btop.enable = true;
    dev-tools.enable = true;
    # firefox.enable = false;
    # fish.enable = true;
    # gh.enable = true;
    git.enable = true;
    # go-chromecast.enable = true;
    # google-chrome.enable = false;
    # google-cloud-sdk.enable = true;
    gpg.enable = true;
    # helix.enable = false;
    home-manager.enable = true;
    #jetbrains.idea-community.enable = true; # Disable for now till I mirgrate from toolbox
    #jetbrains.idea-ultimate.enable = true;
    kde.enable = true;
    kitty.enable = true; # should be install with system package manager to avoid OpenGL GLX failures
    lorri.enable = true;
    navi.enable = true;
    neovim.default = true;
    neovim.enable = true;
    # qmk.enable = true;
    # rclone.enable = true;
    scripts.enable = true;
    slack.enable = false;
    ssh.enable = true;
    taskwarrior.enable = true;
    terraform.enable = true;
    # tig.enable = true;
    # ulauncher.enable = false; # broken on nixos
    vscode.enable = true;
    webapps.google-calendar.enable = true;
    webapps.google-drive.enable = true;
    webapps.google-keep.enable = true;
    webapps.google-mail.enable = true;
    # webapps.google-photos.enable = false;
    # webapps.messenger.enable = false;
    # webapps.telegram.enable = false;
    # webapps.whatsapp.enable = false;
    # webapps.youtube-music.enable = true;
    xdg.enable = true;
    zellij.enable = true;
    zoom-us.enable = true; # broken on wayland
    zsh.enable = true;
  };

  programs = {
    # ssh.includes = [ "${cfg.secretsRootPath}/ssh/config" "~/.ssh/config.local" ];
    zsh = {
      profileExtra = ''
      '';
      initExtra = ''
      '';
      shellAliases = {
        ind = "f(){local project=$(ls $HOME/indeed | fzf); [ -n \"$project\" ] && cd \"$HOME/indeed/$project\"};f;unset -f f";
      };
      dirHashes = {
        indeed = "$HOME/indeed";
        ind = "$HOME/indeed";
      };
    };
    git = {
      includes = [
        {
          condition = "gitdir:~/indeed/";
          contents = {
            user = {
              name = "Konstantin Labun";
              email = "klabun@indeed.com";
            };
          };
        }
        { path = "~/.gitconfig.local"; }
      ];
    };
  };
}
