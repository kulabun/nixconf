{ config, pkgs, lib, ... }:

let cfg = config.settings;
in {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use";
      }
    ];

    history = {
      extended = true;
      ignoreDups = true;
      save = 1000000; # lines to save in file
      size = 10000; # lines to keep in memory
      #share = false;
      path = "$HOME/.zsh_history";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
        "gradle"
        "rust"
        "fzf"
        "vi-mode"
        "ssh-agent"
        "taskwarrior"
        "terraform"
        "tmux"
      ];
      extraConfig = ''
        zstyle :omz:plugins:ssh-agent lazy yes
      '';
    };

    shellAliases = {
      ls = "exa --color=auto --icons";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      cat = "bat --color always --plain";
      grep = "grep --color=auto";
      vim = "nvim";
      vi = "vim";
      v = "vi";
      j = "journalctl --full -e";
      jt = "j -t";
      py = "python3";
      s = "sudo";
      b = "bat";
      c = "cat";
      dd = "dd status=progress";
      diff = "diff --color";
      cal = "cal -y";
      h = "cat ~/.zsh_history | grep --text --color ";
      p = "ps -A f -o user:12,pid,priority,ni,pcpu,pmem,args";
      nh = "unset HISTFILE";
      o = "xdg-open";
      ezh = "$EDITOR ~/.zshrc && source ~/.zshrc";
      outputs = "swaymsg -t get_outputs";
      inputs = "swaymsg -t get_inputs";
      hme = "hm edit";
      hms = "hm switch";
      hmu = "hm update";
      hmes = "hme && hms";
      share = "python3 -m http.server 9000";
      d = "docker";
      dps = "d ps";
      dl = "d logs";
      ip4 = "ip -4 -c -o address";
      ip6 = "ip -6 -c -o address";
      vpn = ''
        (nmcli connection show | grep Indeed > /dev/null && echo "Already connected") || nmcli connection up Indeed --ask'';
      g = "git";
      gl = "gradle";
      chrome = "google-chrome-stable";
      ff = "firefox";
      xev = "wev";
      update = "nx update && hm update";
      tz = "tz US/Pacific US/Central Europe/Moscow";
      n = "navi";

      ".." = "cd ..";
      "~" = "cd ~";
      "~proj" = "cd ~proj";
      "~vim" = "cd ~vim";
      "~zsh" = "cd ~zsh";
      "~nix" = "cd ~nix";
      "~scripts" = "cd ~scripts";
      "~sway" = "cd ~sway";
    };

    shellGlobalAliases = {
      L = "| less";
      J = "| jq";
      G = "| grep";
      C = "| wl-copy";
      H = "| head";
      U = "| up";
    };

    dirHashes = {
      proj = "$HOME/projects";
      vim = "$HOME/nixconf/home-manager/modules/neovim/config";
      zsh = "$HOME/nixconf/home-manager/modules/zsh/config";
      nix = "$HOME/nixconf/";
      scripts = "$HOME/nixconf/home-manager/mondules/scripts";
      sway = "$HOME/nixconf/home-manager/mondules/sway";
    };

    profileExtra = ''
      if [ -z $DISPLAY ] && [ $TTY = "/dev/tty1" ]; then
        # https://wiki.archlinux.org/title/Sway#Automatically_on_TTY_login
        # Disabled as managing sway from homemanager turned out to be a bad idea.
        # Remove slash before dollar sign to start using it.
        systemd-cat --identifier=sway sway
      fi

      if [ -f "$HOME/.zprofile.local" ]; then
        source "$HOME/.zprofile.local"
      fi
    '';

    initExtra = ''
      #NIX_PROFILES=${config.home.profileDirectory}
      if [ -f "$HOME/.zshrc.local" ]; then
        source "$HOME/.zshrc.local"
      fi

      function bind() { 
        bindkey -M vicmd "$1" "$2" > /dev/null
        bindkey -M viins "$1" "$2" > /dev/null
      }

      function unbind() { 
        bindkey -rM vicmd "$1" > /dev/null
        bindkey -rM viins "$1" > /dev/null
      }

      unbind '^[^['
      bind '^S' sudo-command-line

      export FZF_COMPLETION_TRIGGER="*"
      ############################################################
      # ZShell Configuration
      ###########################################################
      export SUDO_PROMPT="$(tput bold)$(tput setaf 1)[sudo] $(tput setaf 7)password for $(tput setaf 6)$USER$(tput setaf 7):$(tput sgr0)"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6f6f6f"
      export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
      export EDITOR=nvim
      # Don't use xterm-256color https://github.com/NvChad/NvChad/issues/926#issuecomment-1108220606
      export TERM=xterm-color
      if [ -z "$NIX_PATH" ]; then
        export NIX_PATH=home-manager=$HOME/.nix-defexpr/channels/home-manager:nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
      fi

      setopt INC_APPEND_HISTORY
      setopt HIST_NO_STORE
      unsetopt BANG_HIST
      unsetopt mail_warning
      unsetopt BEEP
      unset MAILCHECK
      setopt SHORT_LOOPS
      setopt MAGIC_EQUAL_SUBST
      setopt NO_BEEP
      setopt NO_NOMATCH
      setopt NO_HUP
      FIGNORE='.o:.out:.class'
      REPORTTIME=5

      export GPG_TTY=$(tty)
      f() { find . -iname "*$1*" }
      x() { wl-copy <<< $($*) }
      abs() { echo -n $PWD/$1 }

      function ping() {
        if [ $# -eq 0 ]
        then
            =ping google.ch
        else
            =ping "$@"
        fi
      }
    '';
  };
}