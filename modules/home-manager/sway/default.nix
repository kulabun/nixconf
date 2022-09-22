{ config, pkgs, lib, ... }:
let
  toFloat = x: x + 0.0;
  cfg = config.settings;
  font = cfg.programs.sway.font;
in {
  home.file = { "Pictures/swaybg.png".source = ./pictures/nix.png; };
  wayland.windowManager.sway = {
    enable = true;
    package = null; # Package is installed with nixos. Dont install duplicate.
    # Enable sway-session.target to link to graphical-session.target for systemd
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
    config = let
      left = "h";
      down = "j";
      up = "k";
      right = "l";
      mod = "Mod4";
      #terminal = "${pkgs.foot}/bin/foot"; 
      terminal = "${pkgs.foot}/bin/footclient";
    in {
      modifier = "${mod}";
      terminal = "${terminal}";

      workspaceLayout = "stacking";
      defaultWorkspace = "workspace 1";

      fonts = { # Font usedfor window tiles, navbar, ...
        names = [ font.name ];
        size = toFloat font.size;
      };

      gaps = { # Gaps for containters
        inner = 0;
        outer = 0;
      };

      bars = [{
        id = "bar-0";
        position = "top";
        #mode = "hide";
        #hiddenState = "hide";
        command = "waybar";
        extraConfig = ''
          modifier none
        '';
      }];

      startup = [
        { command = "nm-applet --indicator"; }
        { command = "mako"; }
        { command = "ulauncher --hide-window"; }
      ];

      input = { # Input modules: $ man sway-input
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

      floating = { modifier = "${mod}"; };

      keybindings = {
        "${mod}+Delete" = "bar mode toggle";
        "${mod}+Return" = "exec ${terminal}";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+e" =
          "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+Shift+i" = "exec swaylock"; # TODO: it doesnt work

        # Layout control
        "${mod}+z" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+a" = "layout stacking";
        "${mod}+o" = "layout tabbed";
        "${mod}+e" = "layout default";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+Space" = "floating toggle";
        "${mod}+Space" = "focus mode_toggle";
        "${mod}+p" = "focus parent";
        "${mod}+Shift+p" = "focus child";
        "${mod}+n" = "exec ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu";
        "${mod}+s" = "exec ${pkgs.rofi-wayland}/bin/rofi -show power-menu";
 
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
        "Print" = "exec sway-make-screenshot";

        "${mod}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show drun";
      };

      window = {
        border = 1;
        titlebar = false;
        #hideEdgeBorders = "both";

        commands = [
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
            command = "floating enable, sticky enable";
          }
          {
            criteria = { class = "Pavucontrol"; };
            command = "floating enable";
          }
          {
            criteria = { app_id = "ulauncher"; };
            command = "floating enable, border none, move up 300px";
          }
          {
            criteria = { app_id = "zenity"; };
            command = "floating enable, border none, move up 300px";
          }
          # Slack screen sharing
          {
            criteria = {
              app_id = "";
              title = ".* is sharing your screen.";
            };
            command =
              "floating enable, border none, sticky disable, move to scratchpad";
          }
          # Fix for a bug in chrome that make breaks sway hotkeys in chrome-apps
          {
            criteria = { app_id = "^chrome-.*"; };
            command = "shortcuts_inhibitor disable";
          }
          {
            criteria = { class = "^jetbrains-idea$"; };
            command = "border pixel 1";
          }
          {
            criteria = { app_id = "^chrome-app.slack.com.*"; };
            command = "border pixel 1";
          }
          {
            criteria = { app_id = "^chrome-mail.google.com.*"; };
            command = "border pixel 1";
          }
          {
            criteria = { app_id = "^chrome-calendar.google.com.*"; };
            command = "border pixel 1";
          }
          {
            criteria = { app_id = "^chrome-.*.zoom.us.*"; };
            command = "border pixel 1";
          }
          {
            criteria = {
              app_id = "jetbrains-idea";
              title = "win*";
            };
            command =
              "border none, floating enable, move position center, move up 300px";
          }
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

      floating.criteria = [
        {
          app_id = "firefox";
          title = "moz-extension:.+";
        }
        {
          app_id = "firefox";
          title = "Password Required";
        }
      ];
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

      #seat * hide_cursor when-typing enable
      seat * hide_cursor 5000
    '';
  };
}