{ config, pkgs, ... }:
let cfg = config.nixconf.settings;
in {
  imports = [ ../../modules/default ];
  home = {
    enableNixpkgsReleaseCheck = true;
    packages = with pkgs; [ ];
  };

  programs = {
    ssh.includes =
      [ "${cfg.secretsRootPath}/ssh/config" "~/.ssh/config.local" ];
    zsh = {
      profileExtra = ''
        [ -e "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
      '';
      initExtra = ''
        [ -e "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
        [ -e /home/klabun/.nix-profile/etc/profile.d/nix.sh ] && . /home/klabun/.nix-profile/etc/profile.d/nix.sh;
      '';
    };
    git = {
      userName = "Konstantin Labun";
      userEmail = "klabun@indeed.com";

      includes = [
        {
          condition = "gitdir:~/personal/";
          content = {
            userName = "Konstantin Labun";
            userEmail = "konstantin.labun@gmail.com";
          };
        }
        { path = "~/.gitconfig.local"; }
      ];
    };
    sway.config = { output = { "eDP-1".scale = 1; }; };
  };
}

