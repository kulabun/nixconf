{ config
, pkgs
, lib
, ...
}:
with lib; {
  options = {
    settings.fish.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enables fish";
    };
  };

  config = mkIf config.settings.fish.enable {
    home.packages = with pkgs; [
      babelfish
      fishPlugins.forgit
      fishPlugins.done
    ];
    programs.fish = {
      enable = true;
      plugins = [
      ];
      shellInit = ''
        set -x LC_ALL en_US.UTF-8
        set -x LANG en_US.UTF-8
      '';

      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        rg = "rg --color=always --colors 'match:fg:red' --colors 'match:style:bold'";
        bat = "bat --color=always --style=numbers,changes,header";
        fd = "fd --color=always";
        vpn = "nmcli connection show | grep Indeed > /dev/null; and echo \"Already connected\"; or nmcli connection up Indeed --ask";
      };

      shellAbbrs = { };

      shellAliases = {
        ls = "exa --color=auto";
        l = "exa --color=auto --group-directories-first --classify --icons -lh";
        ll = "l -a";
        cat = "bat --plain";
        grep = "grep --color=auto";
        e = "$EDITOR";
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
        share = "python3 -m http.server 9000";
        d = "docker";
        dps = "d ps";
        dl = "d logs";
        ip4 = "ip -4 -c -o address";
        ip6 = "ip -6 -c -o address";
        g = "git";
        gl = "gradle";
        ff = "firefox";
        xev = "wev";
        nxu = "nx update";
        tz = "tz US/Pacific US/Central Europe/Moscow";
        n = "navi";
        scale1 = "source <(scale-x 1)";
        scale2 = "source <(scale-x 2)";
      };
    };
  };
}
