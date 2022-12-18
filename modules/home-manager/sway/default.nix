{ config
, pkgs
, lib
, mylib
, ...
}:
let
  inherit (pkgs) writeScriptBin;

  toFloat = x: x + 0.0;
  font = config.settings.sway.font;
  terminal = config.settings.sway.terminal;
  cursor = config.settings.cursor;

  sway-make-screenshot = writeScriptBin "sway-make-screenshot" (builtins.readFile ./scripts/sway-make-screenshot.sh);
  rofi-gopass = writeScriptBin "rofi-gopass" (builtins.readFile ./scripts/rofi-gopass.sh);
in
with lib;
with mylib; {
  options = {
    settings.sway = {
      enable = mylib.mkEnableOpt "sway";
      font = mylib.mkFontOpt "sway";
      terminal = mylib.mkStrOpt "sway";
    };
  };

  config = mkIf config.settings.sway.enable {
    home = {
      file = {
        "Pictures/swaybg.png".source = ./pictures/nix.png;
      };

      packages = [ 
        sway-make-screenshot 
        rofi-gopass
      ];
    };

    xdg.configFile = {
      "environment.d/sway.conf".source = ./env.d/sway.conf;
    };

    wayland.windowManager.sway = {
      enable = true;
      # package = null; # Package is installed with nixos. Dont install duplicate.
      # Enable sway-session.target to link to graphical-session.target for systemd
      systemdIntegration = true;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      config =
        let
          left = "h";
          down = "j";
          up = "k";
          right = "l";
          mod = "Mod4";
        in
        {
          modifier = "${mod}";
          terminal = "${terminal}";

          # only default layout allow no borders
          # workspaceLayout = "stacking";
          defaultWorkspace = "workspace 1";

          fonts = {
            # Font usedfor window tiles, navbar, ...
            names = [ font.name ];
            size = toFloat font.size;
          };

          gaps = {
            # Gaps for containters
            inner = 2;
            outer = 2;
          };

          bars = [
            {
              id = "bar-0";
              position = "top";
              #mode = "hide";
              #hiddenState = "hide";
              command = "waybar";
              extraConfig = ''
                modifier none
              '';
            }
          ];

          startup = [
            { command = "systemd-cat --identifier=nm-applet nm-applet --indicator "; }
            { command = "systemd-cat --identifier=mako mako"; }
            { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY"; }
            { command = "systemd-cat --identifier=udiskie udiskie --no-automount --tray"; }
            { command = "systemd-cat --identifier=blueberry blueberry-tray"; }
          ];

          assigns = { 
            # browser
            "1" = [
              { app_id = "^firefox$"; }
            ];
            # ide
            "2" = [
              { class = "^jetbrains-[a-z-]+$"; } # class exists only for XWayland apps
              { app_id = "^code-url-handler$"; }
            ];
            # docs
            "6" = [
              { title = "^google-keep$"; app_id = "^(google-webapps|Electron)$"; }
              { title = "^google-docs$"; app_id = "^(google-webapps|Electron)$"; }
              { title = "^google-drive$"; app_id = "^(google-webapps|Electron)$"; }
            ];
            # chat
            "7" = [
              { title = "^slack$"; app_id = "^(slack-webapps|Electron)$"; }
              { title = "^telegram$"; app_id = "^(telegram-webapps|Electron)$"; }
              { title = "^whatsapp$"; app_id = "^(whatsapp-webapps|Electron)$"; }
              { title = "^messenger$"; app_id = "^(meta-webapps|Electron)$"; }
            ];
            # mail
            "8" = [
              { title = "^google-mail$"; app_id = "^(google-webapps|Electron)$"; }
            ];
            # calendar
            "9" = [
              { title = "^google-calendar$"; app_id = "^(google-webapps|Electron)$"; }
            ];
            # conference
            "10" = [
              { 
                title = "^zoom$";
                app_id = "^(zoom-webapps|Electron)$"; 
              }
              { 
                title = "^google-meet$"; 
                app_id = "^(google-webapps|Electron)$"; 
              }
            ];
          };

          input = {
            # Input modules: $ man sway-input
            "type:touchpad" = {
              tap = "disabled";
              dwt = "enabled";
              scroll_method = "two_finger";
              middle_emulation = "disabled";
              natural_scroll = "enabled";
            };
            "type:pointer" = {
              accel_profile = "flat";
              pointer_accel = "-0.4";
              natural_scroll = "disabled";
            };
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_numlock = "disabled";
              repeat_rate = "40";
              repeat_delay = "400";
            };
          };

          output = {
            "*".bg = "$HOME/Pictures/swaybg.png fill";
            "*".scale = "1";
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
          };

          floating = { 
            modifier = "${mod}";
          };

          keybindings = {
            "${mod}+Delete" = "bar mode toggle";
            "${mod}+Shift+Return" = "exec ${terminal}";
            "${mod}+Return" = "exec TARGET_ZELLIJ_SESSION=main ${terminal}";
            "${mod}+Shift+q" = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
            "${mod}+Shift+i" = "exec swaylock";

            # Layout control
            # TODO: move layout change to dedicated mode?
            "${mod}+s" = "layout stacking";
            "${mod}+t" = "layout tabbed";
            "${mod}+e" = "layout default";
            "${mod}+f" = "fullscreen";
            "${mod}+Shift+Space" = "floating toggle";
            "${mod}+Space" = "focus mode_toggle";
            "${mod}+Shift+a" = "focus parent";
            "${mod}+a" = "focus child";
            "${mod}+z" = "splith";
            "${mod}+v" = "splitv";

            "${mod}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";
            "${mod}+n" = "exec ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
            "${mod}+p" = "exec ${pkgs.rofi-wayland}/bin/rofi -show power-menu";
            "${mod}+w" = "exec ${rofi-gopass}/bin/rofi-gopass";
            # TODO:
            # mod + b = [b]luetooth
            # mod + o = s[o]und
            # run/rofi mode?
            # mod + enter:
            # - t terminal
            # - z zellij
            # - w password
            # - p power 
            # - a audio
            # - e editor
            # - n network
            # - b bluetooth
            # - l launcher


            # Scratchpad
            "${mod}+Shift+g" = "move scratchpad";
            "${mod}+g" = "scratchpad show";

            # Movements
            "${mod}+${left}" = "focus left";
            "${mod}+${down}" = "focus down";
            "${mod}+${up}" = "focus up";
            "${mod}+${right}" = "focus right";
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";
            "${mod}+Shift+${left}" = "move left";
            "${mod}+Shift+${down}" = "move down";
            "${mod}+Shift+${up}" = "move up";
            "${mod}+Shift+${right}" = "move right";
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            # Workspaces
            "${mod}+1" = "workspace 1";
            "${mod}+2" = "workspace 2";
            "${mod}+3" = "workspace 3";
            "${mod}+4" = "workspace 4";
            "${mod}+5" = "workspace 5";
            "${mod}+6" = "workspace 6";
            "${mod}+7" = "workspace 7";
            "${mod}+8" = "workspace 8";
            "${mod}+9" = "workspace 9";
            "${mod}+0" = "workspace 10";
            "${mod}+Shift+1" = "move container to workspace 1";
            "${mod}+Shift+2" = "move container to workspace 2";
            "${mod}+Shift+3" = "move container to workspace 3";
            "${mod}+Shift+4" = "move container to workspace 4";
            "${mod}+Shift+5" = "move container to workspace 5";
            "${mod}+Shift+6" = "move container to workspace 6";
            "${mod}+Shift+7" = "move container to workspace 7";
            "${mod}+Shift+8" = "move container to workspace 8";
            "${mod}+Shift+9" = "move container to workspace 9";
            "${mod}+Shift+0" = "move container to workspace 10";
            "Print" = "exec ${sway-make-screenshot}/bin/sway-make-screenshot";
          };

          window = {
            border = 1;
            titlebar = false;
            hideEdgeBorders = "both";

            commands = [
              # Firefox
              { 
                criteria = {
                  app_id = "firefox";
                  title = "moz-extension:.+";
                };
                command = "floating enable";
              }
              {
                criteria = {
                  app_id = "firefox";
                  title = "Password Required";
                };
                command = "floating enable";
              }
              {
                criteria = {
                  app_id = "firefox";
                  title = "About Mozilla Firefox";
                };
                command = "floating enable";
              }
              {
                criteria = {
                  app_id = "firefox";
                  title = "Picture-in-Picture";
                };
                command = "floating enable, sticky enable";
              }
              {
                criteria = {
                  app_id = "firefox";
                  title = "Firefox — Sharing Indicator";
                };
                command = "floating enable, sticky enable, move to scratchpad";
              }

              # Slack screen sharing
              # {
              #   criteria = {
              #     app_id = "";
              #     title = ".* is sharing your screen.";
              #   };
              #   command = "floating enable, move to scratchpad";
              # }

              # Fix for a bug in chrome that make breaks sway hotkeys in chrome-apps
              {
                criteria = { app_id = "^chrome-.*"; };
                command = "shortcuts_inhibitor disable";
              }

              # Floating
              {
                criteria = { app_id = "ulauncher"; };
                command = "floating enable, border none, move up 300px";
              }
              {
                criteria = { app_id = "zenity"; };
                command = "floating enable, border none, move up 300px";
              }
              {
                criteria = {
                  class = "^jetbrains-[a-z-]+$";
                  title = "win*";
                };
                command = "floating enable, move position center, move up 300px";
              }
              {
                criteria = {
                    app_id = "pavucontrol";
                };
                command = "floating enable";
              }
              # {
              #   criteria = { 
              #     app_id = "^code-url-handler$";
              #   };
              #   command = "floating enable";
              # }

              # No border
              {
                criteria = { app_id = "^.*"; };
                # command = "border 1";
                command = "border none";
              }

              # prevent screen lock on full screen
              {
                criteria = { app_id = "^.*"; };
                command = "inhibit_idle fullscreen";
              }
              {
                criteria = { class = "^.*"; };
                command = "inhibit_idle fullscreen";
              }
            ];
          };
        };

      extraConfig = ''
        bindswitch --reload --locked lid:on exec swaymsg output eDP-1 disable
        bindswitch --reload --locked lid:off exec swaymsg output eDP-1 enable

        bindsym --to-code XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +5%'
        bindsym --to-code XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -5%'
        bindsym --to-code XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
        bindsym --to-code XF86AudioRewind exec 'playerctl previous'
        bindsym --to-code XF86AudioPlay exec 'playerctl play-pause'
        bindsym --to-code XF86AudioForward exec 'playerctl next'

        # doesn't work well on websites were you can type in a hover popup
        #seat * hide_cursor when-typing enable
        seat * hide_cursor 5000
        seat * xcursor_theme ${cursor.theme} ${toString cursor.size}
        exec_always {
          gsettings set org.gnome.desktop.interface cursor-theme ${cursor.theme}
          gsettings set org.gnome.desktop.interface cursor-size ${toString cursor.size}
        }
      '';

      # Disabled because it doesn't work when you set package to null. And I have to set it to null on my NixOS and Ubuntu hosts
      #   extraSessionCommands = ''
      #     # TODO: deduplicate it with home.sessionVariables
      #
      #     # Disable HiDPI scaling for X apps
      #     # https://wiki.archlinux.org/index.php/HiDPI#GUI_toolkits
      #     export GDK_SCALE=2
      #
      #     export XDG_SESSION_TYPE=wayland
      #     export XDG_SESSION_DESKTOP=sway
      #     export MOZ_ENABLE_WAYLAND=1
      #     # Tell toolkits to use wayland
      #     export CLUTTER_BACKEND=wayland
      #     export QT_QPA_PLATFORM=wayland-egl
      #     export QT_QPA_PLATFORMTHEME=qt5ct
      #     export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      #     export ECORE_EVAS_ENGINE=wayland-egl
      #     export ELM_ENGINE=wayland_egl
      #     export SDL_VIDEODRIVER=wayland
      #
      #     # Fix Java
      #     export _JAVA_AWT_WM_NONREPARENTING=1
      #
      #     export NO_AT_BRIDGE=1
      #     export QT_AUTO_SCREEN_SCALE_FACTOR=0
      #     export EDITOR=${config.settings.editor}
      #     export VISUAL=${config.settings.editor}
      #     export PAGER="less -R"
      #     export TIME_STYLE="long-iso" # for core-utils
      #     export DEFAULT_BROWSER="firefox"
      #     export MOZ_ENABLE_WAYLAND=1
      #     export MOZ_WEBRENDER=1
      #     export _JAVA_AWT_WM_NONREPARENTING=1
      #     export XDG_SESSION_TYPE="wayland"
      #     export GDK_SCALE=2
      #     export XCURSOR_SIZE=128
      #     export GSETTINGS_SCHEMA_DIR="${pkgs.glib.getSchemaPath pkgs.gtk3}"
      #
      #     # Secrets storage
      #     # TODO: use sops instead
      #     export SECRETS_STORE=${cfg.secretsRootPath}
      #
      #     # Stores nix host profile name
      #     export NIX_HOST=${cfg.machine}
      #   '';
      };
    };
  }
