{ ... }: {
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.kde.enable = false;

  programs.plasma = {
    enable = true;

    workspace = {
      theme = "Nordic";
      colorScheme = "Nordic";
      cursorTheme = "Nordzy-cursors";
      lookAndFeel = "Nordic";
      iconTheme = "Zafiro-Icons-Blue";
    };

    # fonts = {
    #   general = {
    #     family = "DejaVu Sans";
    #     pointSize = 9;
    #   };
    #   fixedWidth = {
    #     family = "DejaVu Sans Mono for Powerline";
    #     pointSize = 9;
    #   };
    # };

    shortcuts = {
      "flameshot.desktop"."Capture" = "Meta+X";
      "Alacritty.desktop"."New" = "Meta+Return";
      "ksmserver"."Lock Session" = [ "Screensaver" "Meta+Shift+A" ];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      bismuth = {
        "decrease_master_size" = "Meta+H";
        "decrease_master_win_count" = "Meta+D";
        "focus_next_window" = "Meta+J";
        "focus_prev_window" = "Meta+K";
        "increase_master_size" = "Meta+L";
        "increase_master_win_count" = "Meta+I";
        "move_window_to_next_pos" = "Meta+Shift+J";
        "move_window_to_prev_pos" = "Meta+Shift+K";
        "next_layout" = "Meta+Shift+Space";
        "push_window_to_master" = "Meta+Shift+Return";
        "toggle_monocle_layout" = "Meta+M";
        "toggle_three_column_layout" = "Meta+Z";
        "toggle_tile_layout" = "Meta+T";
        "toggle_window_floating" = "Meta+F";
      };
      kwin = {
        "Edit Tiles" = [ ];
        "Overview" = [ ];
        "Show Desktop" = [ ];
        "Switch to Desktop 1" = "Meta+1";
        "Switch to Desktop 2" = "Meta+2";
        "Switch to Desktop 3" = "Meta+3";
        "Switch to Desktop 4" = "Meta+4";
        "Switch to Next Desktop" = "Meta+]";
        "Switch to Previous Desktop" = "Meta+[";
        "Window Close" = [ "Alt+F4" "Meta+W" ];
        "Window One Screen Down" = "Meta+Alt+J";
        "Window One Screen Up" = "Meta+Alt+K";
        "Window One Screen to the Left" = "Meta+Alt+H";
        "Window One Screen to the Right" = "Meta+Alt+L";
        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";
      };
      plasmashell = {
        "activate task manager entry 1" = [ ];
        "activate task manager entry 2" = [ ];
        "activate task manager entry 3" = [ ];
        "activate task manager entry 4" = [ ];
      };
    };

    configFile = {
      kwinrc = {
        "Desktops"."Number".value = 4;
        "Desktops"."Rows".value = 1;
        Effect-wobblywindows = {
          "AdvancedMode".value = true;
          "Drag".value = 85;
          "Stiffness".value = 10;
          "WobblynessLevel".value = 1;
        };
        Plugins = {
          "blurEnabled".value = true;
          "bismuthEnabled".value = true;
          "wobblywindowsEnabled".value = true;
        };
        Script-bismuth = {
          "maximizeSoleTile".value = true;
          "noTileBorder".value = false;
          "screenGapBottom".value = 8;
          "screenGapLeft".value = 8;
          "screenGapRight".value = 8;
          "screenGapTop".value = 8;
          "tileLayoutGap".value = 8;
        };
        Compositing = {
          "Enabled".value = true;
          "LatencyPolicy".value = "Low";
          "MaxFPS".value = 144;
          "OpenGLIsUnsafe".value = false;
          "RefreshRate".value = 144;
          "WindowsBlockCompositing".value = false;
          "XRenderSmoothScale".value = true;
        };
      };
    };
  };
}
