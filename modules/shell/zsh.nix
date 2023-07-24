{ config
, lib
, user
, pkgs
, ...
}:
with lib; let
  cfg = config.shell'.zsh;
in
{
  options.shell'.zsh.enable = mkEnableOption "zsh" // { default = true; };

  config = mkIf cfg.enable {

    # Auto-completion wouldn't work if Zsh is enabled only in home-manager.
    # See https://github.com/nix-community/home-manager/issues/2562
    programs.zsh.enable = true;

    home-manager.users.${user} = {
      home.packages = with pkgs; [
        shell-hist # analyze my shell history
      ];
      programs = {
        fzf.enable = true;
        starship.enable = true;
        bat.enable = true;
        exa.enable = true;
        feh.enable = true;
        command-not-found.enable = true;
        # jq.enable = true;
        man.enable = true;
        # tmux.enable = true;
        # go.enable = true;
        zoxide.enable = true;

        zsh = {
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
            ];
            extraConfig = ''
              zstyle :omz:plugins:ssh-agent lazy yes
            '';
          };

          shellAliases = {
            l = "ls --color=auto --group-directories-first --classify --icons -lh";
            la = "l -a";
            lt = "l --tree";
            j = "journalctl --full -e";
            jt = "j -t";
            s = "sudo";
            c = "cat";
            diff = "diff --color";
            cal = "cal -y";
            h = "cat ~/.zsh_history | grep --text --color ";
            p = "ps -A f -o user:12,pid,priority,ni,pcpu,pmem,args";
            nh = "unset HISTFILE";
            o = "xdg-open";
            share = "python3 -m http.server 9000";
            d = "docker";
            ip4 = "ip -4 -c -o address";
            ip6 = "ip -6 -c -o address";
            ff = "firefox";
            xev = "wev";
            nxu = "nx update";
            pr = "f(){local project=$(ls $HOME/projects | fzf); [ -n \"$project\" ] && cd \"$HOME/projects/$project\"};f;unset -f f";
            dd = "dd status=progress";

            ".." = "cd ..";
            "~" = "cd ~";
            "~proj" = "cd ~proj";
            "~vim" = "cd ~vim";
            "~zsh" = "cd ~zsh";
            "~nix" = "cd ~nix";
            "~scripts" = "cd ~scripts";
            "~navi" = "cd ~navi";
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
            nix = "$HOME/nixconf/";
          };

          profileExtra = ''
            [ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
          '';

          initExtra = ''
            [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

            function unbind() {
              if bindkey "$1" > /dev/null; then
                bindkey -rM vicmd "$1" > /dev/null
                bindkey -rM viins "$1" > /dev/null
              fi
            }

            function bind() {
              unbind $1
              bindkey -M vicmd "$1" "$2" > /dev/null
              bindkey -M viins "$1" "$2" > /dev/null
            }

            unbind '^[^['
            bindkey '^t' sudo-command-line

            # Unsuspend VIM
            bindkey -s '^z' 'fg^M'

            export FZF_COMPLETION_TRIGGER="*"
            ############################################################
            # ZShell Configuration
            ###########################################################

            # tab copmpletion
            bindkey '^s' autosuggest-accept

            export SUDO_PROMPT="$(tput bold)$(tput setaf 1)[sudo] $(tput setaf 7)password for $(tput setaf 6)$USER$(tput setaf 7):$(tput sgr0) "
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6f6f6f"
            export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
            # Don't use xterm-256color https://github.com/NvChad/NvChad/issues/926#issuecomment-1108220606
            #export TERM=xterm-color
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

            #########################################################################################################
            # Fix slow paste. See https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
            #########################################################################################################
            pasteinit() {
              OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
              zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
            }

            pastefinish() {
              zle -N self-insert $OLD_SELF_INSERT
            }
            zstyle :bracketed-paste-magic paste-init pasteinit
            zstyle :bracketed-paste-magic paste-finish pastefinish
            #########################################################################################################
          '';
        };
      };
    };
  };
}
