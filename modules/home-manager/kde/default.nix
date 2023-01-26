# Configuration is based on
#   https://github.com/LunNova/nixos-configs/blob/dev/users/lun/on-nixos/kdeconfig.nix
{ config, mylib, lib, pkgs, ... }:
let
  toValue = v:
    if builtins.isString v then
      v
    else if builtins.isBool v then
      lib.boolToString v
    else if builtins.isInt v then
      builtins.toString v
    else if builtins.isFloat v then
      builtins.toString v
    else
      builtins.abort ("Unknown value type: ${builtins.toString v}");
  configs = {
    kwinrulesrc = {
      "1" = {
        Description = "VSCode";
        maximizehoriz = true;
        maximizehorizrule = 3;
        maximizevert = true;
        maximizevertrule = 3;
        noborder = true;
        noborderrule = 3;
        types = 1;
        wmclass = "code code-url-handler";
        wmclasscomplete = true;
        wmclassmatch = 1;
      };

      "2" = {
        Description = "firefox";
        maximizehoriz = true;
        maximizehorizrule = 3;
        maximizevert = true;
        maximizevertrule = 3;
        noborder = true;
        noborderrule = 3;
        types = 1;
        wmclass = "firefox";
        wmclassmatch = 1;
      };

      "3" = {
        Description = "Kitty";
        maximizehoriz = true;
        maximizehorizrule = 3;
        maximizevert = true;
        maximizevertrule = 3;
        noborder = true;
        noborderrule = 3;
        types = 1;
        wmclass = "kitty";
        wmclassmatch = 1;
      };

      "4" = {
        Description = "Electron";
        maximizehoriz = true;
        maximizehorizrule = 3;
        maximizevert = true;
        maximizevertrule = 3;
        noborder = true;
        noborderrule = 3;
        types = 1;
        wmclass = "electron";
        wmclasscomplete = true;
        wmclassmatch = 2;
      };

      General = {
        count = 4;
        rules = "1,2,3,4";
      };
    };
    kwinrc = {
      Desktops = {
        Rows = 1;
        Number = 10;

        Id_1 = "1db77c0c-ef58-4e42-962b-bf37b3c8e1ee";
        Name_1 = 1;

        Id_2 = "a1ea1170-95b0-4338-9b4b-6ec857f79791";
        Name_2 = 2;

        Id_3 = "273e3902-01b0-4b32-b5bd-223a34dfd97c";
        Name_3 = 3;

        Id_4 = "9a0b6e6e-dfc9-47aa-bf2f-0776ab6bc5cb";
        Name_4 = 4;

        Id_5 = "b52a2d57-8186-42af-a144-1e8bdb85ad75";
        Name_5 = 5;

        Id_6 = "6da2676e-cc1a-41c6-9927-b1e966374239";
        Name_6 = 6;

        Id_7 = "0a86bc80-bf2e-41ab-8bb1-5212bab7b1f0";
        Name_7 = 7;

        Id_8 = "1f0ff86f-4317-49f9-b71e-0eb082232d77";
        Name_8 = 8;

        Id_9 = "2d4d9861-7662-4862-91f9-8196729eac43";
        Name_9 = 9;

        Id_10 = "0ca8ce70-6c67-4bd3-b13b-d3a82b727d89";
        Name_10 = 10;
      };
      "Effect-windowview" = {
        BorderActivateAll = 9;
      };
      NightColor = {
        Active = true;
        Mode = "Times";
      };
      Plugins = {
        slideEnabled = false;
      };
    };
    kcminputrc = {
      "Logitech MX Ergo" = {
        NaturalScroll = false;
        PointerAcceleration = -0.750;
        PointerAccelerationProfile = 2;
      };
      Mouse = {
        PointerAcceleration = -0.200;
        PointerAccelerationProfile = 1;
      };
    };
    kded5rc = {
      PlasmaBrowserIntegration = {
        shownCount = 0;
      };
    };
    kdeglobals = {
      KDE = {
        SingleClick = false;
        AnimationDurationFactor = 0;
      };
    };
  };
  lines = lib.flatten (lib.mapAttrsToList
    (file:
      lib.mapAttrsToList
        (group:
          lib.mapAttrsToList
            (key: value:
              "$DRY_RUN_CMD ${pkgs.libsForQt5.kconfig}/bin/kwriteconfig5 --file $confdir/'${file}' --group '${group}' --key '${key}' '${
                toValue value
              }'")
        ))
    configs);
in
with lib;
{
   options = {
      settings.kde = {
        enable = mylib.mkEnableOpt "kde";
        font = mylib.mkFontOpt "kde";
      };
    };

    config = mkIf config.settings.kde.enable {
      home.activation.kwriteconfig5 = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        _() {
          confdir="''${XDG_CONFIG_HOME:-$HOME/.config}"
          ${builtins.concatStringsSep "\n" lines}
          $DRY_RUN_CMD ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.KWin /KWin reconfigure || echo "KWin reconfigure failed"
          for i in {0..10}; do
            $DRY_RUN_CMD ${pkgs.dbus}/bin/dbus-send --type=signal /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:$i int32:0 || echo "KGlobalSettings.notifyChange failed"
          done
        } && _
        unset -f _
      '';
    };
}
