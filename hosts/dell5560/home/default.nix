{ config
, pkgs
, pkgs'
, mylib
, ...
}:
let
  cfg = config.settings;
  # cvm = pkgs.writeShellScriptBin "cvm" (builtins.readFile ./scripts/cvm.sh);
  gr = pkgs.writeShellScriptBin "gr" (builtins.readFile ./scripts/gr.sh);
  venv = pkgs.writeShellScriptBin "venv" (builtins.readFile ./scripts/venv.sh);
  fix-ubuntu-sway = pkgs.writeShellScriptBin "fix-ubuntu-sway" (builtins.readFile ./scripts/fix-ubuntu-sway.sh);
  
  slack-webapp = mylib.makeWebApp {
    name = "slack";
    desktopName = "Slack - Indeed PTE";
    url = "https://app.slack.com/client/T029BFEQ3/C029BFEQR";
    icon = "${pkgs.moka-icon-theme}/share/icons/Moka/48x48/web/com.slack.Slack.png";
  };
in
{
  # Should be enabled if home-manager is running on Non-NixOS Linux
  targets.genericLinux.enable = true;

  imports = [ ../../../modules/home-manager ];

  home = {
    stateVersion = "22.11";
    enableNixpkgsReleaseCheck = true;
    homeDirectory = "/home/${cfg.user}";
    username = "${cfg.user}";
    packages = with pkgs; [
      consul
      vault
      gcc
      # cvm
      gr
      venv
      fix-ubuntu-sway
      slack-webapp
      insomnia
    ];
    # packages = with pkgs; [ consul vault gcc cvm gr venv fix-ubuntu-sway xwayland wlroots glib wayland ];
    # packages = with pkgs; [ consul vault gcc cvm gr venv fix-ubuntu-sway xwayland wlroots glib wayland xdg-desktop-portal-wlr xdg-desktop-portal-gtk xorg.xprop pipewire pipewire-media-session ];
  };

  settings = {
    user = "klabun";
    machine = "dell5560";
    secretsRootPath = "/home/klabun/secrets";
    cursor = {
      theme = "capitaine-cursors-white";
      # theme = "capitaine-cursors";
      size = 32;
    };

    fonts.enable = true;

    awscli2.enable = true;
    btop.enable = true;
    dev-tools.enable = true;
    # firefox.enable = false;
    fish.enable = true;
    flameshot.enable = true;
    gh.enable = true;
    git.enable = true;
    # go-chromecast.enable = true;
    # google-chrome.enable = false;
    # google-cloud-sdk.enable = true;
    gpg.enable = true;
    gtk.enable = true;
    # helix.enable = false;
    home-manager.enable = true;
    #jetbrains.idea-community.enable = true; # Disable for now till I mirgrate from toolbox
    #jetbrains.idea-ultimate.enable = true;
    kitty.enable = true;
    lorri.enable = true;
    navi.enable = true;
    neovim.default = true;
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
    # webapps.google-photos.enable = false;
    # webapps.messenger.enable = false;
    # webapps.telegram.enable = false;
    # webapps.whatsapp.enable = false;
    webapps.youtube-music.enable = true;
    xdg.enable = true;
    zellij.enable = true;
    # zoom-us.enable = false; # broken on wayland
    zsh.enable = true;

    sway.enable = true;
    waybar.enable = true;
    swayidle.enable = true;
    swaylock.enable = true;
    mako.enable = true;
    foot.enable = true;

    sway = {
      terminal = "/usr/bin/kitty";
      # terminal = "${pkgs.kitty}/bin/kitty";
      # terminal = "${pkgs.foot}/bin/footclient";
    };

    gtk.font = {
      name = "DejaVu Sans";
      size = 9;
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

  programs = {
    # ssh.includes = [ "${cfg.secretsRootPath}/ssh/config" "~/.ssh/config.local" ];
    zsh = {
      profileExtra = ''
        # [ -e "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
        # export WLR_NO_HARDWARE_CURSORS=1
        # if [ -z $DISPLAY ] && [ $TTY = "/dev/tty1" ]; then
        #   # https://wiki.archlinux.org/title/Sway#Automatically_on_TTY_login
        #   # Disabled as managing sway from homemanager turned out to be a bad idea.
        #   # Remove slash before dollar sign to start using it.
        #   systemd-cat --identifier=sway ${pkgs.sway}/bin/sway
        # fi
      '';
      initExtra = ''
        # [ -e "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
        #export GDK_SCALE=1
        [ -e /home/klabun/.nix-profile/etc/profile.d/nix.sh ] && . /home/klabun/.nix-profile/etc/profile.d/nix.sh;
      '';
      shellAliases = {
        ind = "f(){local project=$(ls $HOME/indeed | fzf); [ -n \"$project\" ] && cd \"$HOME/indeed/$project\"};f;unset -f f";
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
    zsh.dirHashes = {
      indeed = "$HOME/indeed";
      ind = "$HOME/indeed";
    };
  };

  wayland.windowManager.sway = {
    # package = pkgs.sway;
    package = null; # use system sway
    config = {
      output = {
        "eDP-1".scale = "1.25";
        "HDMI-A-1" = {
          scale = "2";
          resolution = "3840x2160";
          position = "3840,0";
        };
        "HDMI-A-2" = {
          scale = "2";
          resolution = "3840x2160";
          position = "3840,0";
        };
        "DP-3" = {
          scale = "2";
          resolution = "3840x2160";
          position = "0,0";
        };
        "DP-2" = {
          scale = "2";
          resolution = "3840x2160";
          position = "0,0";
        };
        "DP-1" = {
          scale = "2";
          resolution = "3840x2160";
          position = "0,0";
        };
      };
    };
  };
}
