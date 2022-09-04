{ config, pkgs, ... }: {
  imports = [
    ../git
    ../gpg
    ../gtk
    ../ssh
    ../xdg
    ../zsh
    ../fonts
    ../neovim
    ../scripts
    ../home-manager

    ../sway
    ../waybar
    ../swayidle
    ../swaylock
    ../mako
    ../foot
  ];

  programs = {
    fzf.enable = true;
    starship.enable = true;
    bottom.enable = true;
    bat.enable = true;
    exa.enable = true;
    feh.enable = true;
    command-not-found.enable = true;
    jq.enable = true;
    man.enable = true;
    tmux.enable = true;
    go.enable = true;
  };

  home.packages = with pkgs; [ nix-prefetch-scripts nix-index ];

  services = { playerctld.enable = true; };
}

