{
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
      bismuthEnabled = true;
    };
    "Script-bismuth" = {
      enableFloatingLayout = true;
      enableSpiralLayout = false;
      enableStairLayout = false;
      ignoreTitle = "Firefox — Sharing Indicator";
      monocleMaximize = false;
      noTileBorder = true;
      preventMinimize = true;
      screenGapBottom = 20;
      screenGapLeft = 20;
      screenGapRight = 20;
      screenGapTop = 20;
      tileLayoutGap = 20;
    };
    Windows = {
      ElectricBorderMaximize = false;
      ElectricBorderTilling = false;
      Placement = "Centered";
    };
    "org.kde.kdecoration2" = {
      BorderSize = "None";
      BorderSizeAuto = false;
    };
  };

  krunnerrc = {
    General = {
      ActivateWhenTypingOnDesktop = false;
      ActivityAware = false;
      FreeFloating = true;
      HistoryEnabled = false;
      RetainPriorSearch = false;
    };

    Plugins = {
      CharacterRunnerEnabled = false;
      DictionaryEnabled = false;
      appstreamEnabled = false;
      baloosearchEnabled = false;
      bookmarksEnabled = false;
      browserhistoryEnabled = false;
      browsertabsEnabled = false;
      desktopsessionsEnabled = false;
      helprunnerEnabled = false;
      katesessionsEnabled = false;
      konsoleprofilesEnabled = false;
      kwinEnabled = false;
      "org.kde.activities2Enabled" = false;
      "org.kde.datetimeEnabled" = false;
      "org.kde.windowedwidgetsEnabled" = false;
      plasma-desktopEnabled = false;
      recentdocumentsEnabled = false;
      shellEnabled = false;
      webshortcutsEnabled = false;
      windowsEnabled = false;
    };
  };

  konsolerc = {
    General = {
      ConfigVersion = 1;
    };

    KonsoleWindow = {
      RememberWindowSize = false;
    };

    MainWindow = {
      MenuBar = "Disabled";
      ToolBarsMovable = "Disabled";
    };

    TabBar = {
      TabBarPosition = "Top";
    };
  };

  kcminputrc = {
    "Libinput+1133+16495+Logitech MX Ergo" = {
      NaturalScroll = false;
      # PointerAcceleration = -0.200; # kwriteconfig5 cannot write negative numbers as key values
      PointerAccelerationProfile = 1;
    };
    Mouse = {
      # PointerAcceleration = -0.200; # kwriteconfig5 cannot write negative numbers as key values
      PointerAccelerationProfile = 1;
    };
  };

  kglobalshortcutsrc = {
    kwin = {
      # Reset default keybindings
      "view_actual_size" = "none,Meta+0,Zoom to Actual Size";
      "Show Desktop" = "none,Meta+D,Peek at Desktop";

      # Setup new keybindings
      "Switch Window Down" = "Meta+J,Meta+Alt+Down,Switch to Window Below";
      "Switch Window Left" = "Meta+H,Meta+Alt+Left,Switch to Window to the Left";
      "Switch Window Right" = "Meta+L,Meta+Alt+Right,Switch to Window to the Right";
      "Switch Window Up" = "Meta+K,Meta+Alt+Up,Switch to Window Above";

      "Kill Window" = "Meta+Shift+Q,Meta+Ctrl+Esc,Kill Window";
      "Window Close" = "Meta+Q,Alt+F4,Close Window";
      "Window Maximize" = "none,Meta+PgUp,Maximize Window";

      "Switch to Desktop 1" = "Meta+1,Ctrl+F1,Switch to Desktop 1";
      "Switch to Desktop 2" = "Meta+2,Ctrl+F2,Switch to Desktop 2";
      "Switch to Desktop 3" = "Meta+3,Ctrl+F3,Switch to Desktop 3";
      "Switch to Desktop 4" = "Meta+4,Ctrl+F4,Switch to Desktop 4";
      "Switch to Desktop 5" = "Meta+5,Ctrl+F5,Switch to Desktop 5";
      "Switch to Desktop 6" = "Meta+6,Ctrl+F6,Switch to Desktop 6";
      "Switch to Desktop 7" = "Meta+7,Ctrl+F7,Switch to Desktop 7";
      "Switch to Desktop 8" = "Meta+8,Ctrl+F8,Switch to Desktop 8";
      "Switch to Desktop 9" = "Meta+9,Ctrl+F9,Switch to Desktop 9";
      "Switch to Desktop 10" = "Meta+0,Ctrl+F10,Switch to Desktop 10";

      "Window to Desktop 1" = "Meta+!,,Window to Desktop 1";
      "Window to Desktop 2" = "Meta+@,,Window to Desktop 2";
      "Window to Desktop 3" = "Meta+#,,Window to Desktop 3";
      "Window to Desktop 4" = "Meta+$,,Window to Desktop 4";
      "Window to Desktop 5" = "Meta+%,,Window to Desktop 5";
      "Window to Desktop 6" = "Meta+^,,Window to Desktop 6";
      "Window to Desktop 7" = "Meta+&,,Window to Desktop 7";
      "Window to Desktop 8" = "Meta+*,,Window to Desktop 8";
      "Window to Desktop 9" = "Meta+(,,Window to Desktop 9";
      "Window to Desktop 10" = "Meta+),,Window to Desktop 10";
    };

    plasmashell = {
      # Reset default keybindings
      "activate task manager entry 1" = "none,Meta+1,Activate Task Manager Entry 1";
      "activate task manager entry 2" = "none,Meta+2,Activate Task Manager Entry 2";
      "activate task manager entry 3" = "none,Meta+3,Activate Task Manager Entry 3";
      "activate task manager entry 4" = "none,Meta+4,Activate Task Manager Entry 4";
      "activate task manager entry 5" = "none,Meta+5,Activate Task Manager Entry 5";
      "activate task manager entry 6" = "none,Meta+6,Activate Task Manager Entry 6";
      "activate task manager entry 7" = "none,Meta+7,Activate Task Manager Entry 7";
      "activate task manager entry 8" = "none,Meta+8,Activate Task Manager Entry 8";
      "activate task manager entry 9" = "none,Meta+9,Activate Task Manager Entry 9";
      "activate task manager entry 10" = "none,Meta+0,Activate Task Manager Entry 10";
    };
    # App launcher
    "org.kde.krunner.desktop" = {
      "_launch" = "Meta+D,Alt+Space\tAlt+F2\tSearch,KRunner";
    };

    kded5 = {
      "Show System Activity" = "none,Ctrl+Esc,Show System Activity";
      "display" = "Display\tMeta+O,Display\tMeta+P,Switch Display";
    };

    ksmserver = {
      "Lock Session" = "Meta+Shift+Esc,Meta+L\tScreensaver,Lock Session";
    };

    bismuth = {
      "toggle_float_layout" = "Meta+Shift+F,Meta+Shift+F,Toggle Floating Layout";
      "toggle_three_column_layout" = "Meta+Shift+C,,Toggle Three Column Layout";
      "toggle_tile_layout" = "Meta+Shift+T,Meta+T,Toggle Tile Layout";
      "move_window_to_left_pos" = "Meta+Shift+H,Meta+Shift+H,Move Window Left";
      "move_window_to_right_pos" = "Meta+Shift+L,Meta+Shift+L,Move Window Right";
      "push_window_to_master" = "Meta+Return,Meta+Return,Push Active Window to Master Area";
      "toggle_spread_layout" = "Meta+Shift+S,,Toggle Spread Layout";
      "toggle_monocle_layout" = "Meta+Shift+M,Meta+M,Toggle Monocle Layout";
      "toggle_window_floating" = "Meta+F,Meta+F,Toggle Active Window Floating";
    };
  };

  "plasma-arg.kde.plasma.desktop-appletsrc" = {
    "ActionPlugins+0" = {
      "RightButton;NoModifier" = "org.kde.contextmenu";
      "MiddleButton;NoModifier" = null;
      "wheel:Vertical;NoModifier" = null;
    };
  };

  kdeglobals.KDE = {
    SingleClick = false;
    AnimationDurationFactor = 0;
  };

  baloofilerc."Basic Settings".Indexing-Enabled = false;

  ksmserverrc.General.loginMode = "emptySession";
}
