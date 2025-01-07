{ ... }:
{
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.kde.enable = false;

  programs.plasma = {
    enable = true;

    workspace = {
      theme = "Nordic";
      colorScheme = "Nordic";
      # cursorTheme = "Nordzy-cursors";
      lookAndFeel = "Nordic";
      iconTheme = "Zafiro-Icons-Blue";
    };

    shortcuts = {
      "flameshot.desktop"."Capture" = "Meta+X";
      "alacritty-2.desktop"."_launch" = "Meta+Return";
      "ksmserver"."Lock Session" = [
        "Screensaver"
        "Meta+Shift+A"
      ];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      "rofi-2.desktop"."_launch" = "Meta+Space";
      "rofi-3.desktop"."_launch" = "Meta+C";
      "rofi-rbw.desktop"."_launch" = "Alt+Space";
      "io.github.alainm23.planify.quick-add.desktop"."_launch" = "Meta+Shift+P";
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
        "Window Close" = [
          "Alt+F4"
          "Meta+W"
        ];
        "Window Minimize" = [
          "Meta+PgDown"
          "Meta+O"
        ];
        "Window One Screen Down" = "Meta+Alt+J";
        "Window One Screen Up" = "Meta+Alt+K";
        "Window One Screen to the Left" = "Meta+Alt+H";
        "Window One Screen to the Right" = "Meta+Alt+L";
        "Window to Desktop 1" = "Meta+!";
        "Window to Desktop 2" = "Meta+@";
        "Window to Desktop 3" = "Meta+#";
        "Window to Desktop 4" = "Meta+$";

        "KrohnkiteDecrease" = "Meta+D,none,Krohnkite: Decrease";
        "KrohnkiteFloatAll" = "Meta+Shift+F,none,Krohnkite: Toggle Float All";
        "KrohnkiteFocusNext" = "Meta+K,none,Krohnkite: Focus Next";
        "KrohnkiteFocusPrev" = "Meta+J,none,Krohnkite: Focus Previous";
        "KrohnkiteIncrease" = "Meta+I,none,Krohnkite: Increase";
        "KrohnkiteMonocleLayout" = "Meta+M,none,Krohnkite: Monocle Layout";
        "KrohnkiteSetMaster" = "Meta+Shift+Return,none,Krohnkite: Set master";
        "KrohnkiteShrinkWidth" = "Meta+H,none,Krohnkite: Shrink Width";
        "KrohnkiteTileLayout" = "Meta+T,none,Krohnkite: Tile Layout";
        "KrohnkiteToggleFloat" = "Meta+F,none,Krohnkite: Toggle Float";
        "KrohnkitegrowWidth" = "Meta+L,none,Krohnkite: Grow Width";
      };
      plasmashell = {
        "activate task manager entry 1" = [ ];
        "activate task manager entry 2" = [ ];
        "activate task manager entry 3" = [ ];
        "activate task manager entry 4" = [ ];
      };
    };

    configFile = {
      "kglobalshortcutsrc" = {
        "alacritty-2.desktop"."_k_friendly_name" = "alacritty msg create-window || alacritty";
        "rofi-2.desktop"."_k_friendly_name" = "rofi -show run";
        "rofi-3.desktop"."_k_friendly_name" = "rofi -show calc";
        "rofi-rbw.desktop"."_k_friendly_name" = "rofi-rbw";
        "io.github.alainm23.planify.quick-add.desktop"."_k_friendly_name" =
          "io.github.alainm23.planify.quick-add";
      };
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
          "krohnkiteEnabled".value = true;
          "blurEnabled".value = true;
          "magiclampEnabled".value = true;
          "wobblywindowsEnabled".value = true;
        };
        Script-krohnkite = {
          "directionalKeyDwm".value = true;
          "directionalKeyFocus".value = false;
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
        "org.kde.kdecoration2" = {
          "BorderSize".value = "Tiny";
          "BorderSizeAuto".value = false;
        };
      };
      kded5rc = {
        "Module-gtkconfig"."autoload" = false;
      };
    };
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
