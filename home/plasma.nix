{ config, lib, pkgs, ... }:
let
  # plasma-manager stores each rule property as { value, apply }.
  force = value: {
    inherit value;
    apply = "force";
  };
  initially = value: {
    inherit value;
    apply = "initially";
  };
in
{
  # Stylix auto-theming is ass compared to the Nordic package
  stylix.targets.kde.enable = false;
  stylix.targets.qt.enable = false;

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
      "ghostty-launch.desktop"."_launch" = "Meta+Return";
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

        "KrohnkiteDecrease" = "Meta+D";
        "KrohnkiteFloatAll" = "Meta+Shift+F";
        "KrohnkiteFocusNext" = "Meta+K";
        "KrohnkiteFocusPrev" = "Meta+J";
        "KrohnkiteIncrease" = "Meta+I";
        "KrohnkiteMonocleLayout" = "Meta+M";
        "KrohnkiteSetMaster" = "Meta+Shift+Return";
        "KrohnkiteShrinkWidth" = "Meta+H";
        "KrohnkiteTileLayout" = "Meta+T";
        "KrohnkiteToggleFloat" = "Meta+F";
        "KrohnkitegrowWidth" = "Meta+L";
      };
      plasmashell = {
        "activate task manager entry 1" = [ ];
        "activate task manager entry 2" = [ ];
        "activate task manager entry 3" = [ ];
        "activate task manager entry 4" = [ ];
      };
    };

    input.mice = [
      {
        name = "Primax Kensington Eagle Trackball";
        vendorId = "047d";
        productId = "2048";
        acceleration = -0.75;
      }
    ];

    # Maximized windows otherwise keep a titlebar's worth of empty frame on Wayland.
    kwin.borderlessMaximizedWindows = true;
    # Per-desktop tile padding below still has to be cleared; this is the global key.
    kwin.tiling.padding = 0;

    # Wayland clients keep their size hints, and Krohnkite clips to them before
    # asking KWin to place the window. A max size under the tile leaves a gap.
    window-rules = [
      {
        description = "Let Krohnkite fill the tile";
        match.window-types = [ "normal" ];
        apply = {
          ignoregeometry = force true;
          minsize = force "0,0";
          maxsize = force "32767,32767";
          strictgeometry = force false;
          maximizehoriz = initially false;
          maximizevert = initially false;
        };
      }
    ];

    configFile = {
      "kglobalshortcutsrc" = {
        "ghostty-launch.desktop"."_k_friendly_name" = "ghostty +new-window";
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
        Effect-hidecursor."InactivityDuration".value = 3;
        Plugins = {
          "krohnkiteEnabled".value = true;
          "blurEnabled".value = true;
          "hidecursorEnabled".value = true;
          "magiclampEnabled".value = true;
          "wobblywindowsEnabled".value = true;
        };
        Script-krohnkite = {
          "directionalKeyDwm".value = true;
          "directionalKeyFocus".value = false;
          # Replaces krohnkite's default list, so the defaults are repeated
          "ignoreClass".value = builtins.concatStringsSep "," [
            "krunner"
            "yakuake"
            "spectacle"
            "kded5"
            "xwaylandvideobridge"
            "plasmashell"
            "ksplashqml"
            "org.kde.plasmashell"
            "org.kde.polkit-kde-authentication-agent-1"
            "org.kde.kruler"
            "kruler"
            "kwin_wayland"
            "ksmserver-logout-greeter"
            "flameshot"
            "Flameshot"
          ];
          "noTileBorder".value = true;
          "soleWindowNoBorders".value = true;
          "screenGapBetween" = 0;
          "screenGapBottom" = 0;
          "screenGapLeft" = 0;
          "screenGapRight" = 0;
          "screenGapTop" = 0;
          "tileLayoutGap".value = 0;
        };
        Compositing = {
          "Enabled".value = true;
          "LatencyPolicy".value = "Low";
          "MaxFPS".value = 175;
          "OpenGLIsUnsafe".value = false;
          "RefreshRate".value = 175;
          "WindowsBlockCompositing".value = false;
          "XRenderSmoothScale".value = true;
        };
        NightColor = {
          "Active".value = true;
          "NightTemperature".value = 2800;
        };
        "org.kde.kdecoration2" = {
          "BorderSize".value = "Tiny";
          "BorderSizeAuto".value = false;
        };
      };
      breezerc."Windeco Exception 0" = {
        "BorderSize".value = 0;
        "Enabled".value = true;
        "ExceptionPattern".value = ".*";
        "ExceptionType".value = 0;
        "HideTitleBar".value = true;
        "Mask".value = 16;
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

  # the share plugin's download dir is per device, so set it for every paired one
  home.activation.kdeconnectIncomingPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for dev in ${config.xdg.configHome}/kdeconnect/*/; do
      [ -d "$dev" ] || continue
      run mkdir -p "$dev/kdeconnect_share"
      run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file "$dev/kdeconnect_share/config" \
        --group General --key incoming_path /scratch
    done
  '';

  # KWin stores custom-tile padding per desktop and output. The default it
  # wrote is 4, which insets anything snapped into a zone. Krohnkite's own gaps are 0.
  home.activation.kwinTilePadding = lib.hm.dag.entryAfter [ "configure-plasma" ] ''
    cfg="${config.xdg.configHome}/kwinrc"
    if [ -f "$cfg" ]; then
      run ${pkgs.gnused}/bin/sed -i 's/^padding=.*/padding=0/' "$cfg"
    fi
    if [ -n "''${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
      run ${pkgs.dbus}/bin/dbus-send --session --dest=org.kde.KWin --type=method_call \
        /KWin org.kde.KWin.reconfigure || true
    fi
  '';

  # sourced by startplasma; DP-0 is the nvidia X driver's name, wayland calls it something else
  # __GL_SYNC_TO_VBLANK on wayland overrides eglSwapInterval(0) and deadlocks firefox's first paint
  xdg.configFile."plasma-workspace/env/kwin.sh".text = ''
    if [ "$XDG_SESSION_TYPE" = x11 ]; then
      export __GL_SYNC_TO_VBLANK=1
      export __GL_SYNC_DISPLAY_DEVICE=DP-0
      export VDPAU_NVIDIA_SYNC_DISPLAY_DEVICE=DP-0
      export KWIN_X11_NO_SYNC_TO_VBLANK=1
      export KWIN_X11_FORCE_SOFTWARE_VSYNC=1
      export KWIN_X11_REFRESH_RATE=175000
    fi
  '';
}
