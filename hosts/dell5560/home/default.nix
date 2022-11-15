{ config
, pkgs
, ...
}:
let
  cfg = config.settings;
  cvm = pkgs.writeShellScriptBin "cvm" (builtins.readFile ./scripts/cvm.sh);
  gr = pkgs.writeShellScriptBin "gr" (builtins.readFile ./scripts/gr.sh);
  venv = pkgs.writeShellScriptBin "venv" (builtins.readFile ./scripts/venv.sh);
in
{
  imports = [ ../../../modules/home-manager ];
  home = {
    enableNixpkgsReleaseCheck = true;
    packages = with pkgs; [ consul vault gcc cvm gr venv ];
    # packages = with pkgs; [ consul vault gcc cvm gr venv xwayland wlroots glib wayland ];
  };

  settings = {
    # slack.enable = true;
    # zoom-us.enable = true;
    # firefox.enable = true;
  };

  programs = {
    ssh.includes = [ "${cfg.secretsRootPath}/ssh/config" "~/.ssh/config.local" ];
    zsh = {
      profileExtra = ''
        [ -e "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
      '';
      initExtra = ''
        [ -e "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
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

      assigns = {
        "3" = [{ class = "^jetbrains-idea$"; }];
        "7" = [{ app_id = "^chrome-app.slack.com.*"; }];
        "8" = [{ app_id = "^chrome-mail.google.com.*"; }];
        "9" = [{ app_id = "^chrome-calendar.google.com.*"; }];
        "10" = [{ app_id = "^chrome-.*.zoom.us.*"; }];
      };
    };
  };
}
