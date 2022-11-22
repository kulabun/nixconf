{ config
, pkgs
, lib
, mylib
, ...
}:
let
  cfg = config.settings;
in
with lib; {
  options = with mylib; {
    settings = {
      secretsRootPath = mkStrOpt "Secrets root path";
      user = mkStrOpt "user";
      machine = mkStrOpt "machine";
      editor = mkStrOpt "editor";
    };
  };

  imports = [
    ./awscli2
    ./btop
    ./dev-tools
    ./firefox
    ./fish
    ./flameshot
    ./fonts
    ./gh
    ./git
    ./go-chromecast
    ./google-chrome
    ./google-cloud-sdk
    ./gpg
    ./gtk
    ./helix
    ./home-manager
    ./jetbrains
    ./kitty
    ./lorri
    ./navi
    ./neovim
    ./qmk
    ./rclone
    ./rofi
    ./scripts
    ./slack
    ./ssh
    ./taskwarrior
    ./terraform
    ./tig
    ./ulauncher
    ./vscode
    ./xdg
    ./zoom-us
    ./zsh

    ./sway
    ./waybar
    ./swayidle
    ./swaylock
    ./mako
    ./foot
  ];

  config = {
    settings = {
      editor = "nvim";

      fonts.enable = true;

      awscli2.enable = true;
      btop.enable = true;
      dev-tools.enable = true;
      # firefox.enable = false;
      fish.enable = true;
      flameshot.enable = true;
      gh.enable = true;
      git.enable = true;
      go-chromecast.enable = true;
      # google-chrome.enable = false;
      google-cloud-sdk.enable = true;
      gpg.enable = true;
      gtk.enable = true;
      # helix.enable = false;
      home-manager.enable = true;
      jetbrains = {
        idea-community.enable = true;
      };
      kitty.enable = true;
      lorri.enable = true;
      navi.enable = true;
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
      xdg.enable = true;
      # zoom-us.enable = false; # broken on wayland
      zsh.enable = true;

      sway.enable = true;
      waybar.enable = true;
      swayidle.enable = true;
      swaylock.enable = true;
      mako.enable = true;
      foot.enable = true;

      sway = {
        terminal = "${pkgs.foot}/bin/footclient";
        # terminal = "${pkgs.kitty}/bin/kitty";
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
      zoxide.enable = true;
    };

    home = {
      sessionPath = [ "$HOME/.local/bin" "$HOME/bin" ];
      sessionVariables = {
        EDITOR = config.settings.editor;
        VISUAL = config.settings.editor;
        PAGER = "less -R";
        TIME_STYLE = "long-iso"; # for core-utils
        DEFAULT_BROWSER = "firefox";
        MOZ_ENABLE_WAYLAND = 1;
        MOZ_WEBRENDER = 1;
        _JAVA_AWT_WM_NONREPARENTING = 1;
        XDG_SESSION_TYPE = "wayland";
        GSETTINGS_SCHEMA_DIR = "${pkgs.glib.getSchemaPath pkgs.gtk3}";

        # Secrets storage
        # TODO: use sops instead
        SECRETS_STORE = cfg.secretsRootPath;

        # Stores nix host profile name
        NIX_HOST = cfg.machine;
      };

      packages = with pkgs; [
        fend
        dasel
        choose

        nix-prefetch-scripts
        nix-index
        tealdeer
        bashcards # flashcards for learning stuff
        cht-sh
        atool # archive tool
        fwup # firmware updater
        delta # diff tool
        #zellij
        youtube-dl
        #wayshot # screenshot maker
        #slurp # screenshot area selector
        up # realtime preview for bash pipes evaluation
        tz # timezone translator
        ttygif # record shell video to gif
        termtosvg # another shell recorder
        #trashy # safer than rm -rf
        time-decode
        shell-hist # analyze my shell history
        tree
        watson
        fd
        ripgrep
        tmux
        age # file encryption
        psmisc # fuser.- helps to see what process blocks the file

        gopass

        #gdk-pixbuf
        #librsvg # support tray icons in svg
        #awscli
        #nodejs
        #syncthing
        #tmux
        #tmuxp
        #zellij
        #light
        #bitwarden
        unzip
        unrar
        feh
        ranger
        terraform
      ];
    };

    services = {
      #blueman-applet.enable = true; # doesnt work on wayland
      playerctld.enable = true;
    };
  };
}
